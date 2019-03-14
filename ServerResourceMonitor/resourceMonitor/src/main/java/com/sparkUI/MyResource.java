package com.sparkUI;


import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

import java.util.HashMap;
import java.util.Map;

/**
 * Root resource (exposed at "myresource" path)
 */
@Path("myresource")
public class MyResource {


    //public float CPUUsage;
    /**
     * Method handling HTTP GET requests. The returned object will be sent
     * to the client as "text/plain" media type.
     *
     * @return String that will be returned as a text/plain response.
     */
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String getIt() {

        Singleton x = Singleton.getInstance();
        System.out.println("in get = " + x.CPUusage);

        return "Got it, CPU Usage = " + x.ALLHosts;
    }

    @POST
    @Produces(MediaType.TEXT_HTML)
    @Consumes("appli" +
            "cation/x-www-form-urlencoded")
    public String getCPUUasge(@FormParam("usage") String CPUusage,
                              @FormParam("hostname") String HostName){
        System.out.println("in POST = " + CPUusage);

        Singleton x = Singleton.getInstance();
        x.CPUusage = CPUusage;
        x.HostName = HostName;

        x.ALLHosts.put(HostName,CPUusage);
        //this.CPUUsage = Float.valueOf(usage.toString());
        return "Got the value =" + HostName + ":" + CPUusage;
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
        if (single_instance == null)
            single_instance = new Singleton();

        return single_instance;
    }
}
