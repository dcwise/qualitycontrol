import os
import re

def process_markdown(text):
    def replace_function(match):
        full_match = match.group(0)
        if re.match(r'\[.*?\]\(.*?\)', full_match):  # This precisely matches Markdown links
            return full_match
        else:
            return full_match.replace('[', r'\[')

    pattern = r'\[.*?\](?:\(.*?\))?'
    processed_text = re.sub(pattern, replace_function, text)
    return processed_text

def process_files(input_dir, output_dir):
    # Create output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Process each file in the input directory
    for filename in os.listdir(input_dir):
        if filename.endswith('.md'):
            input_path = os.path.join(input_dir, filename)
            output_path = os.path.join(output_dir, filename)

            with open(input_path, 'r', encoding='utf-8') as file:
                content = file.read()

            processed_content = process_markdown(content)

            with open(output_path, 'w', encoding='utf-8') as file:
                file.write(processed_content)

            print(f"Processed: {filename}")

# Usage
input_directory = 'D:/oXygenPOC/LLM/input'
output_directory = 'D:/oXygenPOC/LLM/output'

process_files(input_directory, output_directory)