package org.mahabal.project.handlers;

import com.google.common.hash.Hashing;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.mahabal.project.entity.Session;
import org.mahabal.project.entity.Student;
import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;

public class UserHandler extends AbstractProjectHandler {

    private static final String[] GIRL_NAMES = {"Emma", "Olivia", "Sophia", "Ava", "Isabella", "Mia", "Abigail", "Emily", "Charlotte", "Harper", "Madison", "Amelia", "Elizabeth", "Sofia", "Evelyn", "Avery", "Chloe", "Ella", "Grace", "Victoria", "Aubrey", "Scarlett", "Zoey", "Addison", "Lily", "Lillian", "Natalie", "Hannah", "Aria", "Layla", "Brooklyn", "Alexa", "Zoe", "Penelope", "Riley", "Leah", "Audrey", "Savannah", "Allison", "Samantha", "Nora", "Skylar", "Camila", "Anna", "Paisley", "Ariana", "Ellie", "Aaliyah", "Claire", "Violet", "Stella", "Sadie", "Mila", "Gabriella", "Lucy", "Arianna", "Kennedy", "Sarah", "Madelyn", "Eleanor", "Kaylee", "Caroline", "Hazel", "Hailey", "Genesis", "Kylie", "Autumn", "Piper", "Maya", "Nevaeh", "Serenity", "Peyton", "Mackenzie", "Bella", "Eva", "Taylor", "Naomi", "Aubree", "Aurora", "Melanie", "Lydia", "Brianna", "Ruby", "Katherine", "Ashley", "Alexis", "Alice", "Cora", "Julia", "Madeline", "Faith", "Annabelle", "Alyssa", "Isabelle", "Vivian", "Gianna", "Quinn", "Clara", "Reagan", "Khloe", "Alexandra", "Hadley", "Eliana", "Sophie", "London", "Elena", "Kimberly", "Bailey", "Maria", "Luna", "Willow", "Jasmine", "Kinsley", "Valentina", "Kayla", "Delilah", "Andrea", "Natalia", "Lauren", "Morgan", "Rylee", "Sydney", "Adalynn", "Mary", "Ximena", "Jade", "Liliana", "Brielle", "Ivy", "Trinity", "Josephine", "Adalyn", "Jocelyn", "Emery", "Adeline", "Jordyn", "Ariel", "Everly", "Lilly", "Paige", "Isla", "Lyla", "Makayla", "Molly", "Emilia", "Mya", "Kendall", "Melody", "Isabel", "Brooke", "Mckenzie", "Nicole", "Payton", "Margaret", "Mariah", "Eden", "Athena", "Amy", "Norah", "Londyn", "Valeria", "Sara", "Aliyah", "Angelina", "Gracie", "Rose", "Rachel", "Juliana", "Laila", "Brooklynn", "Valerie", "Alina", "Reese", "Elise", "Eliza", "Alaina", "Raelynn", "Leilani", "Catherine", "Emerson", "Cecilia", "Genevieve", "Daisy", "Harmony", "Vanessa", "Adriana", "Presley", "Rebecca", "Destiny", "Hayden", "Julianna", "Michelle", "Adelyn", "Arabella", "Summer", "Callie", "Kaitlyn", "Ryleigh", "Lila", "Daniela", "Arya", "Alana", "Esther", "Finley", "Gabrielle", "Jessica", "Charlie", "Stephanie", "Tessa", "Makenzie", "Ana", "Amaya", "Alexandria", "Alivia", "Nova", "Anastasia", "Iris", "Marley", "Fiona", "Angela", "Giselle", "Kate", "Alayna", "Lola", "Lucia", "Juliette", "Parker", "Teagan", "Sienna", "Georgia", "Hope", "Cali", "Vivienne", "Izabella", "Kinley", "Daleyza", "Kylee", "Jayla", "Katelyn", "Juliet", "Maggie", "Dakota", "Delaney", "Brynlee", "Keira", "Camille", "Leila", "Mckenna", "Aniyah", "Noelle", "Josie", "Jennifer", "Melissa", "Gabriela", "Allie", "Eloise", "Cassidy", "Jacqueline", "Brynn", "Sawyer", "Evangeline", "Jordan", "Paris", "Olive", "Ayla", "Rosalie", "Kali", "Maci", "Gemma", "Lilliana", "Raegan", "Lena", "Adelaide", "Journey", "Adelynn", "Alessandra", "Kenzie", "Miranda", "Haley", "June", "Harley", "Charlee", "Lucille", "Talia", "Skyler", "Makenna", "Phoebe", "Jane", "Lyric", "Angel", "Elaina", "Adrianna", "Ruth", "Miriam", "Diana", "Mariana", "Danielle", "Jenna", "Shelby", "Nina", "Madeleine", "Elliana", "Amina", "Amiyah", "Chelsea", "Joanna", "Jada", "Lexi", "Katie", "Maddison", "Fatima", "Vera", "Malia", "Lilah", "Madilyn", "Amanda", "Daniella", "Alexia", "Kathryn", "Paislee", "Selena", "Laura", "Annie", "Nyla", "Catalina", "Kayleigh", "Sloane", "Kamila", "Lia", "Haven", "Rowan", "Ashlyn", "Christina", "Amber", "Myla", "Addilyn", "Erin", "Alison", "Ainsley", "Raelyn", "Cadence", "Kendra", "Heidi", "Kelsey", "Nadia", "Alondra", "Cheyenne", "Kaydence", "Mikayla", "River", "Heaven", "Arielle", "Lana", "Blakely", "Sabrina", "Kyla", "Ada", "Gracelyn", "Allyson", "Felicity", "Kira", "Briella", "Kamryn", "Adaline", "Alicia", "Ember", "Aylin", "Veronica", "Esmeralda", "Sage", "Leslie", "Aspen", "Gia", "Camilla", "Ashlynn", "Scarlet", "Journee", "Daphne", "Bianca", "Mckinley", "Amira", "Carmen", "Kyleigh", "Megan", "Skye", "Elsie", "Kennedi", "Averie", "Carly", "Rylie", "Gracelynn", "Mallory", "Emersyn", "Logan", "Camryn", "Annabella", "Dylan", "Elle", "Kiara", "Yaretzi", "Ariella", "Zara", "April", "Gwendolyn", "Anaya", "Baylee", "Brinley", "Sierra", "Annalise", "Tatum", "Serena", "Dahlia", "Macy", "Miracle", "Madelynn", "Briana", "Freya", "Macie", "Helen", "Bethany", "Leia", "Harlow", "Blake", "Jayleen", "Angelica", "Marilyn", "Viviana", "Francesca", "Juniper", "Carolina", "Jazmin", "Emely", "Maliyah", "Cataleya", "Jillian", "Joy", "Abby", "Malaysia", "Nylah", "Sarai", "Evelynn", "Nia", "Zuri", "Addyson", "Aleah", "Kaia", "Bristol", "Lorelei", "Jazmine", "Maeve", "Alejandra", "Justice", "Julie", "Marlee", "Phoenix", "Jimena", "Emmalyn", "Nayeli", "Aleena", "Brittany", "Amara", "Karina", "Giuliana", "Thea", "Braelynn", "Kassidy", "Braelyn", "Luciana", "Aubrie", "Janelle", "Madisyn", "Brylee", "Leighton", "Ryan", "Amari", "Eve", "Millie", "Kelly", "Selah", "Lacey", "Willa", "Haylee", "Jaylah", "Sylvia", "Melany", "Elisa", "Elsa", "Hattie", "Raven", "Holly", "Aisha", "Itzel", "Kyra", "Tiffany", "Jayda", "Michaela", "Madilynn", "Jamie", "Celeste", "Lilian", "Remi", "Priscilla", "Jazlyn", "Karen", "Savanna", "Zariah", "Lauryn", "Alanna", "Kara", "Karla", "Cassandra", "Ariah", "Evie", "Frances", "Aileen", "Lennon", "Charley", "Rosemary", "Danna", "Regina", "Kaelyn", "Virginia", "Hanna", "Rebekah", "Alani", "Edith", "Liana", "Charleigh", "Gloria", "Cameron", "Colette", "Kailey", "Carter", "Helena", "Matilda", "Imani", "Bridget", "Cynthia", "Janiyah", "Marissa", "Johanna", "Sasha", "Kaliyah", "Cecelia", "Adelina", "Jessa", "Hayley", "Julissa", "Winter", "Crystal", "Kaylie", "Bailee", "Charli", "Henley", "Anya", "Maia", "Skyla", "Liberty", "Fernanda", "Monica", "Braylee", "Dallas", "Mariam", "Marie", "Beatrice", "Hallie", "Maryam", "Angelique", "Anne", "Madalyn", "Alayah", "Annika", "Greta", "Lilyana", "Kadence", "Coraline", "Lainey", "Mabel", "Lillie", "Anika", "Azalea", "Dayana", "Jaliyah", "Addisyn", "Emilee", "Mira", "Angie", "Lilith", "Mae", "Meredith", "Guadalupe", "Emelia", "Margot", "Melina", "Aniya", "Alena", "Myra", "Elianna", "Caitlyn", "Jaelynn", "Jaelyn", "Demi", "Mikaela", "Tiana", "Blair", "Shiloh", "Ariyah", "Saylor", "Caitlin", "Lindsey", "Oakley", "Alia", "Everleigh", "Ivanna", "Miah", "Emmy", "Jessie", "Anahi", "Kaylin", "Ansley", "Annabel", "Remington", "Kora", "Maisie", "Nathalie", "Emory", "Karsyn", "Pearl", "Irene", "Kimber", "Rosa", "Lylah", "Magnolia", "Samara", "Elliot", "Renata", "Galilea", "Kensley", "Kiera", "Whitney", "Amelie", "Siena", "Bria", "Laney", "Perla", "Tatiana", "Zelda", "Jaycee", "Kori", "Montserrat", "Lorelai", "Adele", "Elyse", "Katelynn", "Kynlee", "Marina", "Jayden", "Kailyn", "Avah", "Kenley", "Aviana", "Armani", "Dulce", "Alaia", "Teresa", "Natasha", "Milani", "Amirah", "Breanna", "Linda", "Tenley", "Sutton", "Elaine", "Elliott", "Aliza", "Kenna", "Meadow", "Alyson", "Rory", "Milana", "Erica", "Esme", "Leona", "Joselyn", "Madalynn", "Alma", "Chanel", "Myah", "Karter", "Zahra", "Audrina", "Ariya", "Jemma", "Eileen", "Kallie", "Milan", "Emmalynn", "Lailah", "Sloan", "Clarissa", "Karlee", "Laylah", "Amiya", "Collins", "Ellen", "Hadassah", "Danica", "Jaylene", "Averi", "Reyna", "Saige", "Wren", "Lexie", "Dorothy", "Lilianna", "Monroe", "Aryanna", "Elisabeth", "Ivory", "Liv", "Janessa", "Jaylynn", "Livia", "Rayna", "Alaya", "Malaya", "Cara", "Erika", "Amani", "Clare", "Addilynn", "Roselyn", "Corinne", "Paola", "Jolene", "Anabelle", "Aliana", "Lea", "Mara", "Lennox", "Claudia", "Kristina", "Jaylee", "Kaylynn", "Zariyah", "Gwen", "Kinslee", "Avianna", "Lisa", "Raquel", "Jolie", "Carolyn", "Courtney", "Penny", "Royal", "Alannah", "Ciara", "Chaya", "Kassandra", "Milena", "Mina", "Noa", "Leanna", "Zoie", "Ariadne", "Monserrat", "Nola", "Carlee", "Isabela", "Jazlynn", "Kairi", "Laurel", "Sky", "Rosie", "Arely", "Aubrielle", "Kenia", "Noemi", "Scarlette", "Farrah", "Leyla", "Amia", "Bryanna", "Naya", "Wynter", "Hunter", "Katalina", "Taliyah", "Amaris", "Emerie", "Martha", "Thalia", "Christine", "Estrella", "Brenna", "Milania", "Salma", "Lillianna", "Marjorie", "Shayla", "Zendaya", "Aurelia", "Brenda", "Julieta", "Adilynn", "Deborah", "Keyla", "Patricia", "Emmeline", "Hadlee", "Giovanna", "Kailee", "Desiree", "Casey", "Karlie", "Khaleesi", "Lara", "Tori", "Clementine", "Nancy", "Simone", "Ayleen", "Estelle", "Celine", "Madyson", "Zaniyah", "Adley", "Amalia", "Paityn", "Kathleen", "Sandra", "Lizbeth", "Maleah", "Micah", "Aryana", "Hailee", "Aiyana", "Joyce", "Ryann", "Caylee", "Kalani", "Marisol", "Nathaly", "Briar", "Holland", "Lindsay", "Remy", "Adrienne", "Azariah", "Harlee", "Dana", "Frida", "Marianna", "Yamileth", "Chana", "Kaya", "Lina", "Celia", "Analia", "Hana", "Jayde", "Joslyn", "Romina", "Anabella", "Barbara", "Bryleigh", "Emilie", "Nathalia", "Ally", "Evalyn", "Bonnie", "Zaria", "Carla", "Estella", "Kailani", "Rivka", "Rylan", "Paulina", "Kayden", "Giana", "Yareli", "Kaiya", "Sariah", "Avalynn", "Jasmin", "Aya", "Jewel", "Kristen", "Paula", "Astrid", "Jordynn", "Kenya", "Ann", "Annalee", "Kai", "Kiley", "Marleigh", "Julianne", "Zion", "Emmaline", "Nataly", "Aminah", "Amya", "Iliana", "Jaida", "Paloma", "Asia", "Louisa", "Sarahi", "Tara", "Andi", "Arden", "Dalary", "Aimee", "Alisson", "Halle", "Aitana", "Landry", "Alisha", "Elin", "Maliah", "Belen", "Briley", "Raina", "Vienna", "Esperanza", "Judith", "Faye", "Susan", "Aliya", "Aranza", "Yasmin", "Jaylin", "Kyndall", "Saniyah", "Wendy", "Yaritza", "Azaria", "Kaelynn", "Neriah", "Zainab", "Alissa", "Cherish", "Dixie", "Veda", "Nala", "Tabitha", "Cordelia", "Ellison", "Meilani", "Angeline", "Reina", "Tegan", "Hadleigh", "Harmoni", "Kimora", "Ingrid", "Lilia", "Luz", "Aislinn", "America", "Ellis", "Elora", "Heather", "Natalee", "Miya", "Heavenly", "Jenny", "Aubriella", "Emmalee", "Kensington", "Kiana", "Lilyanna", "Tinley", "Ophelia", "Moriah", "Sharon", "Charlize", "Abril", "Avalyn", "Mariyah", "Taya", "Ireland", "Lyra", "Noor", "Sariyah", "Giavanna", "Stevie", "Rhea", "Zaylee", "Denise", "Frankie", "Janiya", "Jocelynn", "Libby", "Aubrianna", "Kaitlynn", "Princess", "Sidney", "Alianna"};
    private static final String[] BOY_NAMES = {"Noah", "Liam", "Mason", "Jacob", "William", "Ethan", "James", "Alexander", "Michael", "Benjamin", "Elijah", "Daniel", "Aiden", "Logan", "Matthew", "Lucas", "Jackson", "David", "Oliver", "Jayden", "Joseph", "Gabriel", "Samuel", "Carter", "Anthony", "John", "Dylan", "Luke", "Henry", "Andrew", "Isaac", "Christopher", "Joshua", "Wyatt", "Sebastian", "Owen", "Caleb", "Nathan", "Ryan", "Jack", "Hunter", "Levi", "Christian", "Jaxon", "Julian", "Landon", "Grayson", "Jonathan", "Isaiah", "Charles", "Thomas", "Aaron", "Eli", "Connor", "Jeremiah", "Cameron", "Josiah", "Adrian", "Colton", "Jordan", "Brayden", "Nicholas", "Robert", "Angel", "Hudson", "Lincoln", "Evan", "Dominic", "Austin", "Gavin", "Nolan", "Parker", "Adam", "Chase", "Jace", "Ian", "Cooper", "Easton", "Kevin", "Jose", "Tyler", "Brandon", "Asher", "Jaxson", "Mateo", "Jason", "Ayden", "Zachary", "Carson", "Xavier", "Leo", "Ezra", "Bentley", "Sawyer", "Kayden", "Blake", "Nathaniel", "Ryder", "Theodore", "Elias", "Tristan", "Roman", "Leonardo", "Camden", "Brody", "Luis", "Miles", "Micah", "Vincent", "Justin", "Greyson", "Declan", "Maxwell", "Juan", "Cole", "Damian", "Carlos", "Max", "Harrison", "Weston", "Brantley", "Braxton", "Axel", "Diego", "Abel", "Wesley", "Santiago", "Jesus", "Silas", "Giovanni", "Bryce", "Jayce", "Bryson", "Alex", "Everett", "George", "Eric", "Ivan", "Emmett", "Kaiden", "Ashton", "Kingston", "Jonah", "Jameson", "Kai", "Maddox", "Timothy", "Ezekiel", "Ryker", "Emmanuel", "Hayden", "Antonio", "Bennett", "Steven", "Richard", "Jude", "Luca", "Edward", "Joel", "Victor", "Miguel", "Malachi", "King", "Patrick", "Kaleb", "Bryan", "Alan", "Marcus", "Preston", "Abraham", "Calvin", "Colin", "Bradley", "Jeremy", "Kyle", "Graham", "Grant", "Jesse", "Kaden", "Alejandro", "Oscar", "Jase", "Karter", "Maverick", "Aidan", "Tucker", "Avery", "Amir", "Brian", "Iker", "Matteo", "Caden", "Zayden", "Riley", "August", "Mark", "Maximus", "Brady", "Kenneth", "Paul", "Jaden", "Nicolas", "Beau", "Dean", "Jake", "Peter", "Xander", "Elliot", "Finn", "Derek", "Sean", "Cayden", "Elliott", "Jax", "Jasper", "Lorenzo", "Omar", "Beckett", "Rowan", "Gael", "Corbin", "Waylon", "Myles", "Tanner", "Jorge", "Javier", "Zion", "Andres", "Charlie", "Paxton", "Emiliano", "Brooks", "Zane", "Simon", "Judah", "Griffin", "Cody", "Gunner", "Dawson", "Israel", "Rylan", "Gage", "Messiah", "River", "Kameron", "Stephen", "Francisco", "Clayton", "Zander", "Chance", "Eduardo", "Spencer", "Lukas", "Damien", "Dallas", "Conner", "Travis", "Knox", "Raymond", "Peyton", "Devin", "Felix", "Jayceon", "Collin", "Amari", "Erick", "Cash", "Jaiden", "Fernando", "Cristian", "Josue", "Keegan", "Garrett", "Rhett", "Ricardo", "Martin", "Reid", "Seth", "Andre", "Cesar", "Titus", "Donovan", "Manuel", "Mario", "Caiden", "Adriel", "Kyler", "Milo", "Archer", "Jeffrey", "Holden", "Arthur", "Karson", "Rafael", "Shane", "Lane", "Louis", "Angelo", "Remington", "Troy", "Emerson", "Maximiliano", "Hector", "Emilio", "Anderson", "Trevor", "Phoenix", "Walter", "Johnathan", "Johnny", "Edwin", "Julius", "Barrett", "Leon", "Tyson", "Tobias", "Edgar", "Dominick", "Marshall", "Marco", "Joaquin", "Dante", "Andy", "Cruz", "Ali", "Finley", "Dalton", "Gideon", "Reed", "Enzo", "Sergio", "Jett", "Thiago", "Kyrie", "Ronan", "Cohen", "Colt", "Erik", "Trenton", "Jared", "Walker", "Landen", "Alexis", "Nash", "Jaylen", "Gregory", "Emanuel", "Killian", "Allen", "Atticus", "Desmond", "Shawn", "Grady", "Quinn", "Frank", "Fabian", "Dakota", "Roberto", "Beckham", "Major", "Skyler", "Nehemiah", "Drew", "Cade", "Muhammad", "Kendrick", "Pedro", "Orion", "Aden", "Kamden", "Ruben", "Zaiden", "Clark", "Noel", "Porter", "Solomon", "Romeo", "Rory", "Malik", "Daxton", "Leland", "Kash", "Abram", "Derrick", "Kade", "Gunnar", "Prince", "Brendan", "Leonel", "Kason", "Braylon", "Legend", "Pablo", "Jay", "Adan", "Jensen", "Esteban", "Kellan", "Drake", "Warren", "Ismael", "Ari", "Russell", "Bruce", "Finnegan", "Marcos", "Jayson", "Theo", "Jaxton", "Phillip", "Dexter", "Braylen", "Armando", "Braden", "Corey", "Kolton", "Gerardo", "Ace", "Ellis", "Malcolm", "Tate", "Zachariah", "Chandler", "Milan", "Keith", "Danny", "Damon", "Enrique", "Jonas", "Kane", "Princeton", "Hugo", "Ronald", "Philip", "Ibrahim", "Kayson", "Maximilian", "Lawson", "Harvey", "Albert", "Donald", "Raul", "Franklin", "Hendrix", "Odin", "Brennan", "Jamison", "Dillon", "Brock", "Landyn", "Mohamed", "Brycen", "Deacon", "Colby", "Alec", "Julio", "Scott", "Matias", "Sullivan", "Rodrigo", "Cason", "Taylor", "Rocco", "Nico", "Royal", "Pierce", "Augustus", "Raiden", "Kasen", "Benson", "Moses", "Cyrus", "Raylan", "Davis", "Khalil", "Moises", "Conor", "Nikolai", "Alijah", "Mathew", "Keaton", "Francis", "Quentin", "Ty", "Jaime", "Ronin", "Kian", "Lennox", "Malakai", "Atlas", "Jerry", "Ryland", "Ahmed", "Saul", "Sterling", "Dennis", "Lawrence", "Zayne", "Bodhi", "Arjun", "Darius", "Arlo", "Eden", "Tony", "Dustin", "Kellen", "Chris", "Mohammed", "Nasir", "Omari", "Kieran", "Nixon", "Rhys", "Armani", "Arturo", "Bowen", "Frederick", "Callen", "Leonidas", "Remy", "Wade", "Luka", "Jakob", "Winston", "Justice", "Alonzo", "Curtis", "Aarav", "Gustavo", "Royce", "Asa", "Gannon", "Kyson", "Hank", "Izaiah", "Roy", "Raphael", "Luciano", "Hayes", "Case", "Darren", "Mohammad", "Otto", "Layton", "Isaias", "Alberto", "Jamari", "Colten", "Dax", "Marvin", "Casey", "Moshe", "Johan", "Sam", "Matthias", "Larry", "Trey", "Devon", "Trent", "Mauricio", "Mathias", "Issac", "Dorian", "Gianni", "Ahmad", "Nikolas", "Oakley", "Uriel", "Lewis", "Randy", "Cullen", "Braydon", "Ezequiel", "Reece", "Jimmy", "Crosby", "Soren", "Uriah", "Roger", "Nathanael", "Emmitt", "Gary", "Rayan", "Ricky", "Mitchell", "Roland", "Alfredo", "Cannon", "Jalen", "Tatum", "Kobe", "Yusuf", "Quinton", "Korbin", "Brayan", "Joe", "Byron", "Ariel", "Quincy", "Carl", "Kristopher", "Alvin", "Duke", "Lance", "London", "Jasiah", "Boston", "Santino", "Lennon", "Deandre", "Madden", "Talon", "Sylas", "Orlando", "Hamza", "Bo", "Aldo", "Douglas", "Tristen", "Wilson", "Maurice", "Samson", "Cayson", "Bryant", "Conrad", "Dane", "Julien", "Sincere", "Noe", "Salvador", "Nelson", "Edison", "Ramon", "Lucian", "Mekhi", "Niko", "Ayaan", "Vihaan", "Neil", "Titan", "Ernesto", "Brentley", "Lionel", "Zayn", "Dominik", "Cassius", "Rowen", "Blaine", "Sage", "Kelvin", "Jaxen", "Memphis", "Leonard", "Abdullah", "Jacoby", "Allan", "Jagger", "Yahir", "Forrest", "Guillermo", "Mack", "Zechariah", "Harley", "Terry", "Kylan", "Fletcher", "Rohan", "Eddie", "Bronson", "Jefferson", "Rayden", "Terrance", "Marc", "Morgan", "Valentino", "Demetrius", "Kristian", "Hezekiah", "Lee", "Alessandro", "Makai", "Rex", "Callum", "Kamari", "Casen", "Tripp", "Callan", "Stanley", "Toby", "Elian", "Langston", "Melvin", "Payton", "Flynn", "Jamir", "Kyree", "Aryan", "Axton", "Azariah", "Branson", "Reese", "Adonis", "Thaddeus", "Zeke", "Tommy", "Blaze", "Carmelo", "Skylar", "Arian", "Bruno", "Kaysen", "Layne", "Ray", "Zain", "Crew", "Jedidiah", "Rodney", "Clay", "Tomas", "Alden", "Jadiel", "Harper", "Ares", "Cory", "Brecken", "Chaim", "Nickolas", "Kareem", "Xzavier", "Kaison", "Alonso", "Amos", "Vicente", "Samir", "Yosef", "Jamal", "Jon", "Bobby", "Aron", "Ben", "Ford", "Brodie", "Cain", "Finnley", "Briggs", "Davion", "Kingsley", "Brett", "Wayne", "Zackary", "Apollo", "Emery", "Joziah", "Lucca", "Bentlee", "Hassan", "Westin", "Joey", "Vance", "Marcelo", "Axl", "Jermaine", "Chad", "Gerald", "Kole", "Dash", "Dayton", "Lachlan", "Shaun", "Kody", "Ronnie", "Kolten", "Marcel", "Stetson", "Willie", "Jeffery", "Brantlee", "Elisha", "Maxim", "Kendall", "Harry", "Leandro", "Aaden", "Channing", "Kohen", "Yousef", "Darian", "Enoch", "Mayson", "Neymar", "Giovani", "Alfonso", "Duncan", "Anders", "Braeden", "Dwayne", "Keagan", "Felipe", "Fisher", "Stefan", "Trace", "Aydin", "Anson", "Clyde", "Blaise", "Canaan", "Maxton", "Alexzander", "Billy", "Harold", "Baylor", "Gordon", "Rene", "Terrence", "Vincenzo", "Kamdyn", "Marlon", "Castiel", "Lamar", "Augustine", "Jamie", "Eugene", "Harlan", "Kase", "Miller", "Van", "Kolby", "Sonny", "Emory", "Junior", "Graysen", "Heath", "Rogelio", "Will", "Amare", "Ameer", "Camdyn", "Jerome", "Maison", "Micheal", "Cristiano", "Giancarlo", "Henrik", "Lochlan", "Bode", "Camron", "Houston", "Otis", "Hugh", "Kannon", "Konnor", "Emmet", "Kamryn", "Maximo", "Adrien", "Cedric", "Dariel", "Landry", "Leighton", "Magnus", "Draven", "Javon", "Marley", "Zavier", "Markus", "Justus", "Reyansh", "Rudy", "Santana", "Misael", "Abdiel", "Davian", "Zaire", "Jordy", "Reginald", "Benton", "Darwin", "Franco", "Jairo", "Jonathon", "Reuben", "Urijah", "Vivaan", "Brent", "Gauge", "Vaughn", "Coleman", "Zaid", "Terrell", "Kenny", "Brice", "Lyric", "Judson", "Shiloh", "Damari", "Kalel", "Braiden", "Brenden", "Coen", "Denver", "Javion", "Thatcher", "Rey", "Dilan", "Dimitri", "Immanuel", "Mustafa", "Ulises", "Alvaro", "Dominique", "Eliseo", "Anakin", "Craig", "Dario", "Santos", "Grey", "Ishaan", "Jessie", "Jonael", "Alfred", "Tyrone", "Valentin", "Jadon", "Turner", "Ignacio", "Riaan", "Rocky", "Ephraim", "Marquis", "Musa", "Keenan", "Ridge", "Chace", "Kymani", "Rodolfo", "Darrell", "Steve", "Agustin", "Jaziel", "Boone", "Cairo", "Kashton", "Rashad", "Gibson", "Jabari", "Avi", "Quintin", "Seamus", "Rolando", "Sutton", "Camilo", "Triston", "Yehuda", "Cristopher", "Davin", "Ernest", "Jamarion", "Kamren", "Salvatore", "Anton", "Aydan", "Huxley", "Jovani", "Wilder", "Bodie", "Jordyn", "Louie", "Achilles", "Kaeden", "Kamron", "Aarush", "Deangelo", "Robin", "Yadiel", "Yahya", "Boden", "Ean", "Kye", "Kylen", "Todd", "Truman", "Chevy", "Gilbert", "Haiden", "Brixton", "Dangelo", "Juelz", "Osvaldo", "Bishop", "Freddy", "Reagan", "Frankie", "Malaki", "Camren", "Deshawn", "Jayvion", "Leroy", "Briar", "Jaydon", "Antoine"};


    public UserHandler(DBI dbi) {
        super(dbi);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.addHeader("Access-Control-Allow-Origin", "*");

        // get IP address
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null) ip = req.getRemoteAddr();

        // first check and see if this is an ID and token, if it is, just validate it


        try (Handle h = dbi.open()) {

            final HashSet<String> set = new HashSet<>();
            List<String> boyName = Arrays.asList(BOY_NAMES);
            boyName.forEach(String::toLowerCase);
            List<String> girlName = Arrays.asList(GIRL_NAMES);
            girlName.forEach(String::toLowerCase);
            set.addAll(girlName);
            set.addAll(boyName);

            final LinkedList<String> NAME_COLLECTION = new LinkedList<>();
            for (final String n : set) {
                if (!NAME_COLLECTION.contains(n.toLowerCase()))
                    NAME_COLLECTION.add(n.toLowerCase());
            }
            Collections.shuffle(NAME_COLLECTION);

            final int create = new Random().nextInt(100) + 100;
            for (int i = 0; i < create; i++) {

                System.out.println(NAME_COLLECTION.size());

                String name = NAME_COLLECTION.poll().toLowerCase();
                final String salt = Hashing.sha512().hashString(String.valueOf(new Random().nextDouble()),
                        Charset.forName("UTF-8")).toString().substring(0, 12);
                // generate a newly salted hash from the md5 password, them trim it to 36 characters
                final String pwHash = Hashing.sha512().hashString(salt + "password", Charset.forName("UTF-8"))
                        .toString().substring(0, 36);
                h.insert("insert into student (uid, username, password, salt, email) values(?,?,?,?,?)",
                        1, name, pwHash, salt, name + "@knights.ucf.edu");
                System.out.println("Student created: " + name);

            }

        }
    }

}
