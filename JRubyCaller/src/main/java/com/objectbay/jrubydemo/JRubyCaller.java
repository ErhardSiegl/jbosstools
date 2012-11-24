package com.objectbay.jrubydemo;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

import javax.script.ScriptEngine;
import javax.script.ScriptException;

import org.jruby.embed.jsr223.JRubyScriptEngineManager;

public class JRubyCaller {

	private ScriptEngine engine;

	public JRubyCaller() throws ScriptException {
		JRubyScriptEngineManager manager = new JRubyScriptEngineManager();
		engine = manager.getEngineByName("jruby");
	}

	public static void main(String[] args) throws MalformedURLException,
			FileNotFoundException, ScriptException {
		JRubyCaller caller = new JRubyCaller();

		caller.callScript(
				new URL("file://" + new File(args[0]).getAbsolutePath()), args);
	}

	protected void callScript(URL url, String[] args)
			throws FileNotFoundException, ScriptException {
		FileReader reader = new FileReader(url.getFile());
		try {

			engine.put("args", args);
			engine.eval(reader);
		} finally {
			try {
				reader.close();
			} catch (IOException e) {
			}
		}
	}

}
