package com.sqrrl.provisioning;

import org.apache.curator.RetryPolicy;
import org.apache.curator.framework.CuratorFramework;
import org.apache.curator.framework.CuratorFrameworkFactory;
import org.apache.curator.retry.ExponentialBackoffRetry;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.FileInputStream;
import java.util.Properties;

/**
 * Created with IntelliJ IDEA.
 * User: Steffen Roegner
 * Date: 11/19/13
 * Time: 10:40 AM
 */
public class ZookeeperAvailableTest {

    private CuratorFramework client;

    @Before
    public void setupZkConn() {
        Properties prop = new Properties();
        try {
            String fileName = System.getenv("TEST_PROPERTIES_FILE");
            System.err.println("Reading master IP from " + fileName );
            prop.load(new FileInputStream(fileName));
            String zkConnStr = prop.getProperty("ci.accumulo.master") + ":2181";
            System.err.println("Will attempt to connect " + zkConnStr );
            RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 3);
            client = CuratorFrameworkFactory.newClient(zkConnStr, retryPolicy);
            client.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @After
    public void stopClient(){
        client.close();
    }

    @Test
    public void testZkAvailable() {
        try {
            client.getData().forPath("/zookeeper");
        } catch (Exception e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

    @Test
    public void testAccumuloInitialized() throws Exception {
        client.getData().forPath("/accumulo/instances/accumulo");
    }
}
