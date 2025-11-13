import 'dart:math';

class MotivationalService {
  static final List<String> _messages = [
    "Gratitude turns what we have into enough.",
    "Every day may not be good, but there's good in every day.",
    "The more grateful you are, the more present you become.",
    "Gratitude is the fairest blossom which springs from the soul.",
    "When you focus on the good, the good gets better.",
    "Gratitude unlocks the fullness of life.",
    "Be thankful for what you have; you'll end up having more.",
    "Gratitude makes sense of our past, brings peace for today, and creates a vision for tomorrow.",
    "The struggle ends when gratitude begins.",
    "Gratitude is not only the greatest of virtues, but the parent of all others.",
    "In ordinary life, we hardly realize that we receive a great deal more than we give.",
    "Cultivate the habit of being grateful for every good thing that comes to you.",
    "Gratitude is the healthiest of all human emotions.",
    "The roots of all goodness lie in the soil of appreciation for goodness.",
    "Acknowledging the good that you already have is the foundation for all abundance.",
    "Gratitude is a powerful catalyst for happiness.",
    "When I started counting my blessings, my whole life turned around.",
    "Gratitude is the sign of noble souls.",
    "Wear gratitude like a cloak and it will feed every corner of your life.",
    "Gratitude is the best attitude.",
    "Enjoy the little things, for one day you may look back and realize they were the big things.",
    "Gratitude changes everything.",
    "The thankful heart opens our eyes to a multitude of blessings.",
    "Start each day with a grateful heart.",
    "Happiness is the spiritual experience of living every minute with love, grace, and gratitude.",
    "Gratitude is the wine for the soul. Go on. Get drunk.",
    "Let us be grateful to the people who make us happy.",
    "The way to develop the best that is in a person is by appreciation and encouragement.",
    "Gratitude is riches. Complaint is poverty.",
    "Be present in all things and thankful for all things.",
  ];

  static String getRandomMessage() {
    final random = Random();
    return _messages[random.nextInt(_messages.length)];
  }

  static String getDailyMessage(DateTime date) {
    // Use date as seed for consistent daily message
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final random = Random(seed);
    return _messages[random.nextInt(_messages.length)];
  }
}
