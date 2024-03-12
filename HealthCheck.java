import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

public class HealthCheck {

    public static void main(String[] args) {
        String url = "http://localhost:8081/v2/check?language=en-US&text=my+text"; // Replace with your actual URL
        try {
            URL endpoint = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) endpoint.openConnection();

            // Set request method
            connection.setRequestMethod("GET");

            // Check if the response code is 200 (HTTP OK)
            int responseCode = connection.getResponseCode();
            if (responseCode != 200) {
                String errString = "Received non-OK response: " + responseCode;
                System.out.println(errString);
                throw new RuntimeException(errString);
            }

            // Check if the response content type is JSON
            String contentType = connection.getHeaderField("Content-Type");
            if (contentType == null || !contentType.toLowerCase().contains("application/json")) {
                String errString = "Received non-JSON response: " + contentType;
                System.out.println(errString);
                throw new RuntimeException(errString);
            }

        } catch (IOException e) {
            String errString = "Error querying " + url;
            System.out.println(errString + "\n" + e.toString());
            throw new RuntimeException(errString, e);
        }
    }
}
