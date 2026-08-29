import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

public class QRCodeGenerator {

    public static void main(String[] args) {
        // String text = "https://example.com"; // QRコード化したいURLや文字列
        // String text = "FullName\t島　和之\nUserName\tshima\nDomainName\thiroshima-cu.ac.jp";
        // String text = "mailto:島　和之 <shima@hiroshima-cu.ac.jp>";
        String text = args[0];
        // String filePath = "qrcode.png"; // 保存先ファイルパス
        String filePath = args[1]; // 保存先ファイルパス
        int width = 300; // 幅 (px)
        int height = 300; // 高さ (px)

        try {
            generateQRCodeImage(text, width, height, filePath);
            System.out.println("QRコードの生成に成功しました: " + filePath);
        } catch (WriterException | IOException e) {
            System.err.println("QRコードの生成中にエラーが発生しました: " + e.getMessage());
        }
    }

    public static void generateQRCodeImage(String text, int width, int height, String filePath)
            throws WriterException, IOException {

        QRCodeWriter qrCodeWriter = new QRCodeWriter();

        // オプションの設定
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8"); // 日本語の文字化け防止
        // hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H); // 誤り訂正レベル(H=高:約30%復元可能)
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L); // 誤り訂正レベル(H=高:約30%復元可能)
        hints.put(EncodeHintType.MARGIN, 2); // 余白のサイズ (セル単位)

        // QRコードデータの生成
        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height, hints);

        // 画像ファイルとして保存
        Path path = FileSystems.getDefault().getPath(filePath);
        MatrixToImageWriter.writeToPath(bitMatrix, "PNG", path);
    }
}
