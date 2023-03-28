import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertThrows;

public class ConfirmVulnerabilitiesTests {

    @Test
    public void confirmCVE202238751 () {
        assertThrows(
                StackOverflowError.class,
                () -> Driver.parse("../payloads/CVE-2022-38751.yml")
        );
    }

    @Test
    public void confirmCVE202238749 () {
        assertThrows(
                StackOverflowError.class,
                () -> Driver.parse("../payloads/CVE-2022-38749.yml")
        );
    }
}
