package edu.brandeis.cs12b.pa07.Tests;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.Arrays;

import org.junit.Test;

import edu.brandeis.cs12b.pa07.KnowledgeBase;

public class ExtraCreditTests {
//	@Test
//	public void extraCreditTestPaths() {
//		KnowledgeBase kb = new KnowledgeBase();
//		
//		kb.storeIsA("apple", "fruit");
//		kb.storeIsA("fruit", "food");
//		kb.storeIsA("apple", "company");
//		String output = kb.findPaths("apple");
//		String[] paths = output.split("\\r?\\n");
//		Arrays.sort(paths);
//		String[] expected = new String[]{"company -> apple", "food -> fruit -> apple"};
//		assertArrayEquals(expected, paths);
//		
//		kb = new KnowledgeBase();
//		kb.storeIsA("color of apples", "color");
//		kb.storeIsA("primary color", "color");
//		kb.storeIsA("red", "color of apples");
//		kb.storeIsA("red", "primary color");
//		
//		output = kb.findPaths("red");
//		paths = output.split("\\r?\\n");
//		Arrays.sort(paths);
//		expected = new String[]{"color -> color of apples -> red", "color -> primary color -> red"};
//		assertArrayEquals(expected, paths);
//		
//		assertEquals(null, kb.findPaths("notInKB"));
//	}
//	
//	@Test
//	public void extraCreditTestSiblings() {
//		KnowledgeBase kb = new KnowledgeBase();
//		
//		kb.storeIsA("apple", "fruit");
//		kb.storeIsA("orange", "fruit");
//		assertFalse(kb.isA("apple", "orange")); //return false
//		assertTrue(kb.isSiblingOf("apple", "orange")); //return true
//		
//		kb = new KnowledgeBase();
//		
//		kb.storeIsA("bulldog", "dog");
//		kb.storeIsA("chihuahua", "dog");
//		assertTrue(kb.isSiblingOf("bulldog", "chihuahua")); //returns true
//		
//		kb.storeIsA("dog", "animal");
//		kb.storeIsA("cat", "animal");
//
//		assertTrue(kb.isSiblingOf("dog", "cat")); //returns true
//		assertFalse(kb.isSiblingOf("bulldog", "cat")); //returns false
//	}
//	
//	@Test
//	public void extraCreditTestHasA() {
//		KnowledgeBase kb = new KnowledgeBase();
//		kb.storeHasA("shoes", "laces");
//		assertTrue(kb.hasA("shoes", "laces"));
//		kb.storeHasA("doctor", "shoes");
//		assertTrue(kb.hasA("doctor", "laces"));
//		assertFalse(kb.hasA("doctor", "doctor"));
//		
//		kb = new KnowledgeBase();
//		kb.storeIsA("doctor", "person");
//		kb.storeHasA("person", "shoes");
//		kb.storeHasA("shoes", "laces");
//		assertTrue(kb.hasA("doctor", "laces"));
//		
//		assertFalse(kb.hasA("something not in the tree", "something else not in the tree"));
//		assertFalse(kb.hasA("person", "something not in the tree"));
//	}
}
