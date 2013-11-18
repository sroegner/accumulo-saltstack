/**
 * Created with IntelliJ IDEA.
 * User: steffen
 * Date: 11/18/13
 * Time: 5:19 AM
 * To change this template use File | Settings | File Templates.
 */

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class HdfsAvailibleTest {

    private Configuration conf;
    private FileSystem fileSystem;
    Properties prop;


    @BeforeClass
    public void setup() {
        conf = new Configuration();
        try {
            String fileName = System.getenv("TEST_PROPERTIES_FILE");
            prop.load(new FileInputStream(fileName));
            conf.set("fs.default.name", prop.getProperty("ci.accumulo.master") + ":8020");
            fileSystem = FileSystem.get(conf);
        } catch (Exception e) {
            e.printStackTrace();

        }
    }

    @Test
    public void testHdfsAvailable() {
        Path path = new Path("/");
        try {
            Boolean has_root = fileSystem.exists(path);
            Assert.assertTrue(has_root);
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

    @Test
    public void testAccumuloInitialized() {
        Path path = new Path("/accumulo/instance_id");
        try {
            Boolean has_root = fileSystem.exists(path);
            Assert.assertTrue(has_root);
        } catch (IOException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

}