#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>

#define DEFAULT_UPDATE_INTERVAL 60
#define DEFAULT_PORT            9
#define DEFAULT_OFFSET          4000
#define DEFAULT_TABLE_SIZE      256

typedef struct {
    char *username;
    int port;
    int used; // 0=空, 1=使用中
} Entry;

static Entry *table = NULL;
static int TABLE_SIZE = DEFAULT_TABLE_SIZE;
static int UPDATE_INTERVAL = DEFAULT_UPDATE_INTERVAL;
static int DEFAULT_PORT_NUM = DEFAULT_PORT;
static int OFFSET = DEFAULT_OFFSET;

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

/* ハッシュ関数 */
unsigned int hash(const char *str) {
    unsigned int h = 0;
    while (*str) {
        h = (h * 131) + *str++;
    }
    return h % TABLE_SIZE;
}

void clear_table() {
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (table[i].used) {
            free(table[i].username);
            table[i].username = NULL;
            table[i].port = 0;
            table[i].used = 0;
        }
    }
}

/* エントリ追加（オープンアドレス法） */
void insert_entry(const char *user, int port) {
    unsigned int idx = hash(user);
    for (int i = 0; i < TABLE_SIZE; i++) {
        unsigned int pos = (idx + i) % TABLE_SIZE;
        if (!table[pos].used) {
            table[pos].username = strdup(user);
            table[pos].port = port;
            table[pos].used = 1;
            return;
        }
    }
    // テーブル満杯なら捨てる
}

/* /etc/passwd を読み込む */
void load_passwd() {
    FILE *fp = fopen("/etc/passwd", "r");
    if (!fp) return;

    pthread_mutex_lock(&lock);

    clear_table();

    char line[1024];
    while (fgets(line, sizeof(line), fp)) {
        char *user = strtok(line, ":");
        strtok(NULL, ":"); // skip password field
        char *uid_str = strtok(NULL, ":");
        if (!user || !uid_str) continue;

        int uid = atoi(uid_str);
        int port = OFFSET + uid;

        insert_entry(user, port);
    }

    pthread_mutex_unlock(&lock);
    fclose(fp);
}

/* 定期的に /etc/passwd をリロード */
void *updater(void *arg) {
    while (1) {
        load_passwd();
        sleep(UPDATE_INTERVAL);
    }
    return NULL;
}

/* ユーザ名からポートを検索 */
int lookup_port(const char *user) {
    unsigned int idx = hash(user);
    pthread_mutex_lock(&lock);
    for (int i = 0; i < TABLE_SIZE; i++) {
        unsigned int pos = (idx + i) % TABLE_SIZE;
        if (table[pos].used && strcmp(table[pos].username, user) == 0) {
            int port = table[pos].port;
            pthread_mutex_unlock(&lock);
            return port;
        }
        if (!table[pos].used) break; // 途中で空なら存在しない
    }
    pthread_mutex_unlock(&lock);
    return DEFAULT_PORT_NUM;
}

/* コマンド引数をパース */
void parse_args(int argc, char *argv[]) {
    for (int i = 1; i < argc; i++) {
        if (strncmp(argv[i], "--update-interval=", 18) == 0) {
            UPDATE_INTERVAL = atoi(argv[i] + 18);
        } else if (strncmp(argv[i], "--default-port=", 15) == 0) {
            DEFAULT_PORT_NUM = atoi(argv[i] + 15);
        } else if (strncmp(argv[i], "--offset=", 9) == 0) {
            OFFSET = atoi(argv[i] + 9);
        } else if (strncmp(argv[i], "--table-size=", 13) == 0) {
            TABLE_SIZE = atoi(argv[i] + 13);
        } else if (strcmp(argv[i], "--help") == 0) {
            fprintf(stderr,
                "Usage: %s [--update-interval=N] [--default-port=N] [--offset=N] [--table-size=N]\n",
                argv[0]);
            exit(0);
        }
    }
}

int main(int argc, char *argv[]) {
    parse_args(argc, argv);

    table = calloc(TABLE_SIZE, sizeof(Entry));
    if (!table) {
        fprintf(stderr, "memory allocation failed\n");
        return 1;
    }

    load_passwd();

    pthread_t tid;
    pthread_create(&tid, NULL, updater, NULL);

    char user[256];
    while (fgets(user, sizeof(user), stdin)) {
        user[strcspn(user, "\r\n")] = 0; // trim newline
        int port = lookup_port(user);
        printf("%d\n", port);
        fflush(stdout);
    }

    return 0;
}
