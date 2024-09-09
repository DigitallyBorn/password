import random
import json

# Function to load words from a file
def load_words_from_file(filename):
    try:
        with open(filename, 'r') as file:
            words = file.read().splitlines()
            if not words:
                raise ValueError(f"{filename} is empty.")
            return words
    except FileNotFoundError:
        print(f"Error: The file '{filename}' was not found.")
        exit(1)
    except ValueError as e:
        print(e)
        exit(1)

# Character to symbol (leet-speak) mapping
leet_mapping = {
    'a': '@',
    's': '$',
    'i': '!',
    'l': '|',
    'e': '3',
    'o': '0',
    't': '7',
    'g': '9'
}

# Function to replace a character in a word with its corresponding symbol
def replace_with_symbol(word):
    available_indices = [i for i, char in enumerate(word) if char.lower() in leet_mapping]
    if not available_indices:
        return word  # No replaceable character found
    
    # Choose a random index of a replaceable character
    index = random.choice(available_indices)
    char_to_replace = word[index].lower()
    
    # Replace it with its symbol equivalent
    symbol = leet_mapping[char_to_replace]
    
    return word[:index] + symbol + word[index+1:]

# Function to capitalize a random letter in a word
def random_capitalize(word):
    index = random.randint(0, len(word) - 1)
    return word[:index] + word[index].upper() + word[index+1:]

# Function to generate the password
def generate_password(adjectives, nouns):
    # Step 1: Select one random adjective and one random noun
    adjective = random.choice(adjectives)
    noun = random.choice(nouns)
    
    # Step 2: Randomly capitalize a letter in one of the words
    if random.choice([True, False]):
        adjective = random_capitalize(adjective)
    else:
        noun = random_capitalize(noun)
    
    # Step 3: Replace a character in one of the words with a similar-looking symbol
    if random.choice([True, False]):
        adjective = replace_with_symbol(adjective)
    else:
        noun = replace_with_symbol(noun)
    
    # Step 4: Combine the adjective and noun with a space in between
    password = adjective + " " + noun
    
    return password

def lambda_handler(event, context):
    # Load adjectives and nouns from files in the Lambda working directory
    adjectives = load_words_from_file('/var/task/adjectives.txt')
    nouns = load_words_from_file('/var/task/nouns.txt')
    
    # Generate the password
    password = generate_password(adjectives, nouns)
    
    # Prepare the response for API Gateway
    response = {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": {
            "password": password
        }
    }
    
    # API Gateway requires the body to be a string, so we serialize the body dictionary to JSON
    response["body"] = json.dumps(response["body"])
    
    return response