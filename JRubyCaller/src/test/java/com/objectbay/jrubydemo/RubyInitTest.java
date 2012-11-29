package com.objectbay.jrubydemo;

import java.io.FileNotFoundException;
import java.net.URL;

import javax.script.ScriptException;

import org.junit.Test;

public class RubyInitTest {

	@Test
	public void test() throws FileNotFoundException, ScriptException {
		JRubyCaller caller = new JRubyCaller();
		URL url = ClassLoader.getSystemResource("hello.rb");
		caller.callScript(url, null);
	}

	@Test
	public void test_callrb_rb() throws FileNotFoundException, ScriptException {
		JRubyCaller caller = new JRubyCaller();
		URL url = ClassLoader.getSystemResource("callrb.rb");
		caller.callScript(url, null);
	}

	@Test
	public void test_callrb_system() throws FileNotFoundException,
			ScriptException {
		JRubyCaller caller = new JRubyCaller();
		URL url = ClassLoader.getSystemResource("callrb_system.rb");
		caller.callScript(url, null);
	}

}
