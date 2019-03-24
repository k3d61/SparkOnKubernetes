package com.sparkUI;


import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Root resource (exposed at "myresource" path)
 */
@Path("myresource")
public class MyResource {

    public String readFileContents(String path){
        ClassLoader classLoader = new MyResource().getClass().getClassLoader();

        File file = new File(classLoader.getResource(path).getFile());
        File fileEnd = new File(classLoader.getResource(path).getFile());

        //        File file = new File("");

        FileInputStream fis = null;
        try {
            fis = new FileInputStream(file);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        byte[] data = new byte[(int) file.length()];
        try {
            fis.read(data);
            fis.close();
            fis.read(data);
        }  catch (Exception e) {
            e.printStackTrace();
        }
        String str = "Nothing";
        try {
            str = new String(data, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return str;
    }

    //public float CPUUsage;
    /**
     * Method handling HTTP GET requests. The returned object will be sent
     * to the client as "text/plain" media type.
     *
     * @return String that will be returned as a text/plain response.
     */
    @GET
    @Produces(MediaType.TEXT_HTML)
    public String getIt() {

        Singleton x = Singleton.getInstance();

        String headFilePath = "HTML/header.html";
        String endFilePath = "HTML/end.html";
        String content = "<br>";

        Iterator it = x.ALLHosts.entrySet().iterator();
        //content = x.ALLHosts.toString();

        content = content + "<div class=\"collection\">";
    /*<a href="#!" class="collection-item"><span class="badge">1</span>Alan</a>
    <a href="#!" class="collection-item"><span class="new badge">4</span>Alan</a>
    <a href="#!" class="collection-item">Alan</a>
    <a href="#!" class="collection-item"><span class="badge">14</span>Alan</a>
*/
        content = content +
                "<div class=\"row collection-item\">" +
                "<div class=\"col s3\">Hostname</div>"+
                "<div class=\"col s3\">CPU Utilazation </div>"+
                "<div class=\"col s3\">Total Memory</div>"+
                "<div class=\"col s3\">Used Memory</div>"+
                "</div>" ;
        while (it.hasNext()) {
            Map.Entry pair = (Map.Entry)it.next();
            System.out.println(pair.getKey() + " = " + pair.getValue());

            String values = pair.getValue().toString();
            String hostname = pair.getKey().toString();

            
            String CPUUtilazation = values.split("@")[0];
            String MemTotal = values.split("@")[1];
            String MemUsed = values.split("@")[2];

            content = content +
                    "<div class=\"row collection-item\">" +
                    "<div class=\"col s3\">"+ values+"</div>"+
/*
                    "<div class=\"col s3\">"+ CPUUtilazation +"</div>"+
                    "<div class=\"col s3\">"+ MemTotal +"</div>"+
                    "<div class=\"col s3\">"+ MemUsed +"</div>"+
*/
                    "</div>" ;
        }

        content = content + "</div>";

                String toBeReturned = readFileContents(headFilePath) + content + readFileContents(endFilePath);
        return toBeReturned;


    }

    @POST
    @Produces(MediaType.TEXT_HTML)
    @Consumes("application/x-www-form-urlencoded")
    public String getCPUUasge(@FormParam("usage") String CPUusage,
                              @FormParam("hostname") String HostName,
                              @FormParam("memtotal")String MemTotal,
                              @FormParam("memused")String MemUsed){
        System.out.println("in POST = " + CPUusage);

        Singleton x = Singleton.getInstance();
        x.CPUusage = CPUusage;
        x.HostName = HostName;

        x.ALLHosts.put(HostName,CPUusage+"@"+MemTotal+"@"+MemUsed);


        return "Got the value =" + HostName + ":" + CPUusage + " : "+ MemTotal + " : " + MemUsed;
    }
}

class Singleton
{
    // static variable single_instance of type Singleton
    private static Singleton single_instance = null;

    // variable of type String
    public String HostName;
    public String CPUusage;

    Map<String, String> ALLHosts = new HashMap<>();

    // private constructor restricted to this class itself
    private Singleton()
    {
        HostName = "Initial Value";
        CPUusage = "Initial value";
    }

    // static method to create instance of Singleton class
    public static Singleton getInstance()
    {
        if (single_instance == null) {
            single_instance = new Singleton();
        /*    for ( int i = 1 ; i <= 18 ; i++ ){
                single_instance.ALLHosts.put("spark-"+i, "0");
            }*/
        }
        return single_instance;
    }
}
