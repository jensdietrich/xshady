import org.yaml.snakeyaml.Yaml;

import java.io.*;

public class Driver {

    public static void main (String[] args) throws IOException {
        if (args.length==0) throw new IllegalArgumentException("one argument required -- the input file");
        File input = new File(args[0]);
        if (!input.exists()) throw new IllegalArgumentException("input file does not exist: " + input.getAbsolutePath());
        parse(input);
    }

    public static void parse (File input) throws IOException {
        try (FileReader reader = new FileReader(input)) {
            new Yaml().compose(reader);
        }
    }

    public static void parse (String input) throws IOException {
        parse(new File(input));
    }
}
