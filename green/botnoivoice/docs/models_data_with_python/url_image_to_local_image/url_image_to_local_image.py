import re

# Load the existing Dart code
dart_file_path = '/mnt/data/SpeakerModel_camelCase.dart'
with open(dart_file_path, 'r', encoding='utf-8') as dart_file:
    dart_code_content = dart_file.read()

# Update the regex function to handle cases with spaces or special characters in the URL paths
def update_square_image_path_extended(match):
    """
    This function updates squareImage URLs by generating the corresponding local assets path,
    handling spaces and other special characters in the URLs.
    """
    url = match.group(1)
    # Extract the image name from the URL, handling spaces or special characters
    image_name_match = re.search(r'square_([\w\s\(\)-]+)\.webp', url)
    if image_name_match:
        # Clean up the extracted name by replacing spaces with underscores to match local asset naming convention
        image_name = image_name_match.group(1).replace(" ", "_")
        return f"squareImage: 'assets/square_image/square_{image_name}.webp',"
    return match.group(0)  # Return the original if no match is found

# Apply the updated regex substitution to handle extended cases with spaces and special characters
updated_dart_code_content_extended = re.sub(
    r'squareImage:\s*\'(https?://[^,]+)\',',
    update_square_image_path_extended,
    dart_code_content
)

# Save the further modified Dart code
updated_dart_file_path_extended = '/mnt/data/Updated_SpeakerModel_camelCase_Extended.dart'
with open(updated_dart_file_path_extended, 'w', encoding='utf-8') as updated_dart_file_extended:
    updated_dart_file_extended.write(updated_dart_code_content_extended)

updated_dart_file_path_extended
