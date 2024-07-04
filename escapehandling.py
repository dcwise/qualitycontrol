import os
import re
import shutil

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
    
    # Process each file and subdirectory in the input directory
    for item in os.listdir(input_dir):
        input_path = os.path.join(input_dir, item)
        output_path = os.path.join(output_dir, item)
        
        if os.path.isdir(input_path):
            # Recursively process subdirectories
            process_files(input_path, output_path)
        elif item.endswith('.md'):
            # Process markdown files
            with open(input_path, 'r', encoding='utf-8') as file:
                content = file.read()
            
            processed_content = process_markdown(content)
            
            with open(output_path, 'w', encoding='utf-8') as file:
                file.write(processed_content)
            
            print(f"Processed: {item}")
        elif item.endswith('.dita') or item.endswith('.ditamap'):
            # Copy DITA XML files without processing
            shutil.copy2(input_path, output_path)
            print(f"Copied DITA file: {item}")
        else:
            # Copy all other files without processing
            shutil.copy2(input_path, output_path)
            print(f"Copied file: {item}")

# Usage
input_directory = 'F:/KLX-201-sw/input'
output_directory = 'F:/KLX-201-sw/output'

process_files(input_directory, output_directory)
