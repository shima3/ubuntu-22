#define _GNU_SOURCE
#include <security/pam_appl.h>
#include <security/pam_misc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// コールバック関数（PAMがパスワードを要求したときに渡す）
static int pam_conv_func(int num_msg,
                         const struct pam_message **msg,
                         struct pam_response **resp,
                         void *appdata_ptr) {
    struct pam_response *reply = NULL;
    reply = (struct pam_response *)calloc(num_msg, sizeof(struct pam_response));
    if (reply == NULL) return PAM_CONV_ERR;

    const char *password = (const char *)appdata_ptr;

    for (int i = 0; i < num_msg; i++) {
        if (msg[i]->msg_style == PAM_PROMPT_ECHO_OFF) {
            reply[i].resp = strdup(password);
        } else if (msg[i]->msg_style == PAM_PROMPT_ECHO_ON) {
            reply[i].resp = strdup(password);
        } else {
            reply[i].resp = NULL;
        }
    }

    *resp = reply;
    return PAM_SUCCESS;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "使い方: %s <username>\n", argv[0]);
        return 1;
    }

    char *username = argv[1];
    char password[256];

    // パスワードを標準入力から取得（エコーなしで）
    printf("Password: ");
    fflush(stdout);
    if (fgets(password, sizeof(password), stdin) == NULL) {
        fprintf(stderr, "パスワード読み込み失敗\n");
        return 1;
    }

    // 改行削除
    password[strcspn(password, "\n")] = '\0';

    struct pam_conv conv = { pam_conv_func, (void *)password };
    pam_handle_t *pamh = NULL;
    int retval = pam_start("common-auth", username, &conv, &pamh);

    if (retval == PAM_SUCCESS) {
        retval = pam_authenticate(pamh, 0);
    }

    if (retval == PAM_SUCCESS) {
        retval = pam_acct_mgmt(pamh, 0);
    }

    if (retval == PAM_SUCCESS) {
        printf("認証成功: user=%s\n", username);
    } else {
        printf("認証失敗: %s\n", pam_strerror(pamh, retval));
    }

    pam_end(pamh, retval);
    return (retval == PAM_SUCCESS ? 0 : 1);
}
