package com.pivotal.cf_examples;

import org.junit.Test;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class TwitterSearchSample {

	@Test
	public void runDemo() throws Exception{
		new ClassPathXmlApplicationContext("META-INF/TwitterSearch-context.xml");

		Thread.sleep(5000);
	}
}
