package edu.brandeis.cs12b.pa07.Tests;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;


import java.util.Arrays;

import org.junit.Test;

import edu.brandeis.cs12b.pa07.KnowledgeBase;

public class KnowledgeBaseTest {
	
	
	@Test
	public void givenTest1() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("watermelon", "fruit");
		kb.storeIsA("apple", "fruit");
		kb.storeIsA("fuji", "apple");
		
		assertTrue("a watermelon is a fruit", kb.isA("watermelon", "fruit"));
		assertTrue("an apple is a fruit", kb.isA("apple", "fruit"));
		assertTrue("a fuji is a fruit", kb.isA("fuji", "fruit"));
		
		assertFalse("a fruit is not a watermelon", kb.isA("fruit", "watermelon"));


	}
	
	@Test
	public void givenTest2() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("alpha", "greek letter");
		kb.storeIsA("beta", "greek letter");
		kb.storeIsA("gamma", "greek letter");
		kb.storeIsA("a", "roman letter");
		kb.storeIsA("b", "roman letter");
		kb.storeIsA("c", "roman letter");
		
		kb.storeIsA("greek letter", "letter");
		kb.storeIsA("roman letter", "letter");


		
		assertTrue("an alpha is a letter", kb.isA("alpha", "letter"));
		assertTrue("a b is a roman letter", kb.isA("b", "roman letter"));
		assertTrue("a greek letter is a letter", kb.isA("greek letter", "letter"));
		
		assertFalse("a b is not a greek letter", kb.isA("b", "greek letter"));


	}
	
	@Test
	public void givenTest3() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("CS12b", "Brandeis course");
		kb.storeIsA("CS50", "Harvard course");
		kb.storeIsA("CS227", "Arizona course");
		kb.storeIsA("Pinnapple", "Fruit");
		kb.storeIsA("Harvard course", "private college course");
		kb.storeIsA("Brandeis course", "private college course");
		kb.storeIsA("Arizona course", "public college course");
		kb.storeIsA("private college course", "college course");
		kb.storeIsA("public college course", "college course");
		kb.storeIsA("college course", "course");



		
		assertTrue("CS12b is a course", kb.isA("CS12b", "course"));
		assertTrue("Arizona course is a public course", kb.isA("Arizona course", "public college course"));
		assertTrue("a pinnapple is a fruit", kb.isA("Pinnapple", "Fruit"));
		
		assertFalse("a course is not CS50", kb.isA("course", "CS50"));

	}
	
	@Test
	public void givenTest4() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("time flies like", "an arrow");
		kb.storeIsA("fruit flies like", "a banana");
		kb.storeIsA("a banana", "fruit");
		kb.storeIsA("Ryan", "TA");
	
		
		assertFalse("closed world assumption", kb.isA("something", "something else"));

	}
	
	@Test
	public void testInsertTopDown() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("Car", "Vehicle");
		kb.storeIsA("SnowPlow", "Vehicle");
		kb.storeIsA("LeftSnowPlow", "SnowPlow");
		
		assertTrue("working when inserting top down", kb.isA("LeftSnowPlow", "Vehicle"));
		assertTrue("branches don't count as parents", !kb.isA("LeftSnowPlow", "Car"));
	}
	
	@Test
	public void testInsertBottomUp() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("LeftSnowPlow", "SnowPlow");
		kb.storeIsA("SnowPlow", "Vehicle");
		
		assertTrue("working when inserting from bottom up", kb.isA("LeftSnowPlow", "Vehicle"));
	}
	
	@Test
	public void testInsertBothDirections() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("LeftSnowPlow", "SnowPlow");
		kb.storeIsA("SnowPlow", "Vehicle");
		kb.storeIsA("Car", "Vehicle");
		
		assertTrue("working when inserting both directions", kb.isA("LeftSnowPlow", "Vehicle"));
		assertTrue("working when inserting both directions", kb.isA("Car", "Vehicle"));
	}
	
	@Test
	public void testDisconnectedKnowledgeBase() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("LeftSnowPlow", "SnowPlow");
		kb.storeIsA("SnowPlow", "Vehicle");
		kb.storeIsA("Car", "Vehicle");
		kb.storeIsA("Apple","Fruit");
		kb.storeIsA("Fruit", "Food");
		
		assertTrue("working with disconnected roots", kb.isA("Apple", "Food"));
		assertTrue("working with disconnected roots", !kb.isA("Food", "Vehicle"));
	}
	
	@Test
	public void testMultiPathways() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("Fruit", "Food");
		kb.storeIsA("Vegetable", "Food");
		kb.storeIsA("Tomato", "Fruit");
		kb.storeIsA("Tomato","Vegetable");
		
		assertTrue(kb.isA("Tomato", "Vegetable"));
		assertTrue(kb.isA("Tomato", "Fruit"));
		assertTrue(kb.isA("Tomato", "Food"));
	}
	
	@Test
	public void testCorrectOrdering() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("Fruit", "Food");
		
		assertTrue(!kb.isA("Food", "Fruit"));
	}
	
	@Test
	public void testBigKnowledgeBase1() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("LeftSnowPlow", "SnowPlow");
		kb.storeIsA("SnowPlow", "Vehicle");
		kb.storeIsA("Car", "Vehicle");
		kb.storeIsA("SnowMobile", "Vehicle");
		kb.storeIsA("GarbageTruck", "Vehicle");
		kb.storeIsA("Bicycle", "Vehicle");
		kb.storeIsA("Bicycle", "Toy");
		kb.storeIsA("MountainBike", "Bicycle");
		kb.storeIsA("Bicycle", "Vehicle");
		
		assertTrue(kb.isA("Bicycle", "Toy"));
		assertTrue(kb.isA("Bicycle", "Vehicle"));
		assertTrue(kb.isA("MountainBike", "Toy"));
		assertTrue(kb.isA("MountainBike", "Vehicle"));
	}
	
	@Test
	public void testBigKnowledgeBase2() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("PA", "Homework");
		kb.storeIsA("PA6", "PA");
		kb.storeIsA("Hard PA", "PA");
		kb.storeIsA("PA", "Computer Science Problem");
		kb.storeIsA("Hard Assignment", "Hard PA");
		
		assertTrue(!kb.isA("PA6", "Hard Assignment"));
		assertTrue(!kb.isA("Computer Science Problem", "PA6"));
		assertTrue(kb.isA("PA6", "Computer Science Problem"));
		assertTrue(kb.isA("Hard PA", "Computer Science Problem"));
	}
	
	@Test
	public void testBigKnowledgeBase3() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("Animal", "Living Thing");
		kb.storeIsA("Invertebrate", "Animal");
		kb.storeIsA("Insect", "Invertebrate");
		kb.storeIsA("Mosquitto", "Insect");
		kb.storeIsA("Anopheles", "Mosquitto");
		
		assertTrue(kb.isA("Anopheles", "Living Thing"));
		assertTrue(!kb.isA("Animal", "Mosquitto"));
	}
	
	@Test
	public void testBigKnowledgeBase4() {
		KnowledgeBase kb = new KnowledgeBase();
		
		for (int i = 0; i < 100; i++){
			kb.storeIsA("Switch " + i, "Button");
		}
		for (int i = 0; i < 100; i++){
			assertTrue(kb.isA("Switch " + i, "Button"));
		}
	}
	
	@Test
	public void testBigKnowledgeBase5() {
		KnowledgeBase kb = new KnowledgeBase();
		
		for (int i = 0; i < 100; i++){
			kb.storeIsA("Button", "Switch " + i);
		}
		for (int i = 0; i < 100; i++){
			assertTrue(kb.isA("Button", "Switch " + i));
		}
	}
	
	@Test
	public void testBigKnowledgeBase6() {
		KnowledgeBase kb = new KnowledgeBase();
		
		for (int i = 0; i < 100; i++){
			kb.storeIsA("Button", "Switch " + i);
			for (int j = 0; j < 25; j++){
				kb.storeIsA("Light " + j, "Switch " + i);
			}
		}
		for (int i = 0; i < 100; i++){
			assertTrue(kb.isA("Button", "Switch " + i));
			for (int j = 0; j <25; j++){
				assertTrue(kb.isA("Light " + j, "Switch " + i));
			}
		}
	}
	
	@Test
	public void testDontIgnoreCapitalization() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("LeftSnowPlow", "SnowPlow");
		kb.storeIsA("leftSnowPlow", "LeftSnowPlow");
		kb.storeIsA("SomeOtherSnowPlow", "LeftSnowPlow");
		
		assertTrue("don't ignore capitalization", kb.isA("leftSnowPlow", "LeftSnowPlow"));
		assertTrue("don't ignore capitalization", !kb.isA("SomeOtherSnowPlow", "leftSnowPlow"));
	}
	
	@Test
	public void testSpaceSafe() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("Left Snow Plow", "Snow Plow");
		kb.storeIsA("Snow Plow", "Vehicle");
		kb.storeIsA("Car", "Vehicle");
		
		assertTrue("working when inserting both directions", kb.isA("Left Snow Plow", "Vehicle"));
		assertTrue("working when inserting both directions", kb.isA("Car", "Vehicle"));
	}
	
	@Test
	public void testRepetition() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("Car", "Vehicle");
		kb.storeIsA("Car", "Vehicle");
		kb.storeIsA("Car", "Vehicle");
		kb.storeIsA("Car", "Vehicle");
		
		assertTrue(kb.isA("Car", "Vehicle"));
	}
	
	
	@Test
	public void testReflexive() {
		KnowledgeBase kb = new KnowledgeBase();
		
		kb.storeIsA("apple", "fruit");
		
		assertTrue("reflexivity", kb.isA("apple", "apple"));
	}
}
