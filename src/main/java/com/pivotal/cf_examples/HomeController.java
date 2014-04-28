package com.pivotal.cf_examples;

import java.util.Iterator;

import javax.annotation.Resource;

import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.Cloud;
import org.springframework.cloud.CloudFactory;
import org.springframework.cloud.service.ServiceInfo;
import org.springframework.cloud.service.common.RabbitServiceInfo;
import org.springframework.cloud.service.common.RelationalServiceInfo;
import org.springframework.integration.Message;
import org.springframework.integration.MessageChannel;
import org.springframework.integration.message.GenericMessage;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {
    @Autowired AmqpTemplate amqpTemplate;
    @Resource(name="twitterOut") MessageChannel twitterOut; 
    
    String rabbitURI=null;
    String dbURL=null;
    
    public HomeController(){
    	Cloud cloud = new CloudFactory().getCloud();
    	Iterator<ServiceInfo> services = cloud.getServiceInfos().iterator();
    	while (services.hasNext()){
    		ServiceInfo svc = services.next();
    		if (svc instanceof RabbitServiceInfo){
    			rabbitURI=((RabbitServiceInfo)svc).getUri();
    		}
    		else if (svc instanceof RelationalServiceInfo){
    			dbURL = ((RelationalServiceInfo)svc).getJdbcUrl();
    		}
    	}
    	
    }
    
    
    @RequestMapping(value = "/")
    public String home(Model model) {
    	model.addAttribute("rabbitURI", rabbitURI);
    	if (dbURL!=null) model.addAttribute("dbURL", dbURL);
        model.addAttribute("tweet", new Tweet());
        return "WEB-INF/views/getFeeds.jsp";
    }
/*
    @RequestMapping(value = "/publish", method=RequestMethod.POST)
    public String publish(Model model, Tweet message) {
        // Send a message to the "messages" queue
        amqpTemplate.convertAndSend("messages", message.getValue());
        model.addAttribute("published", true);
        return home(model);
    }

    @RequestMapping(value = "/get", method=RequestMethod.POST)
    public String get(Model model) {
    	
    	
        // Receive a message from the "messages" queue
        String message = (String)amqpTemplate.receiveAndConvert("messages");
        if (message != null)
            model.addAttribute("got", message);
        else
            model.addAttribute("got_queue_empty", true);

        return home(model);
    }
  */
    
    @RequestMapping(value = "/publish", method=RequestMethod.POST)
    public String sendMsg(Model model, Tweet tweet) {

    	Message<String> twitterUpdate = new GenericMessage<String>(tweet.getValue());
        model.addAttribute("published", true);
    	twitterOut.send(twitterUpdate);
    	return "WEB-INF/views/getFeeds.jsp";
    }
    
    @RequestMapping(value = "/tweet")
    public @ResponseBody String sendTweet(String tweet) {

    	Message<String> twitterUpdate = new GenericMessage<String>(tweet);
        twitterOut.send(twitterUpdate);
    	return "";
    }
    
    
    @RequestMapping(value = "/getFeeds")
    public String getFeeds(Model model) {
    	
        return "WEB-INF/views/getFeeds.jsp";
    }
    
    @RequestMapping(value="/searchTwitter")
    public @ResponseBody String search(){
    	
    	StringBuffer output = new StringBuffer();
    	String msg = null;

    	do{
    		
    		msg = (String)amqpTemplate.receiveAndConvert("ingest.queue");
    		if (msg!=null)output.append("<p><span>Tweet</span>").append(msg).append("</p>");
    		
    	}while (msg!=null);
    	
    	return output.toString();

    }    
    
}
