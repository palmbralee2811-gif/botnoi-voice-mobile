import json

# Load the JSON data from the uploaded file
file_path = '/mnt/data/response_new_update_13-11-2024'
with open(file_path, 'r', encoding='utf-8') as file:
    json_data = json.load(file)

# Function to convert snake_case to camelCase
def to_camel_case(snake_str):
    components = snake_str.split('_')
    return components[0] + ''.join(x.title() for x in components[1:])

# Generate Dart code from the JSON data
dart_code_lines = [
    "import 'package:botnoivoice/domain/entities/speaker_entity.dart';\n",
    "\n",
    "/// Model for Speaker Entity class for Speaker Model in Database\n",
    "class SpeakerModel {\n",
    "  static const List<SpeakerEntity> speakerItem = [\n"
]

# Iterate through each speaker in the JSON data and format it to Dart class format
for speaker in json_data.get("data", []):
    dart_code_lines.append("    SpeakerEntity(\n")
    for key, value in speaker.items():
        camel_case_key = to_camel_case(key)
        if isinstance(value, str):
            dart_code_lines.append(f"      {camel_case_key}: '{value}',\n")
        elif isinstance(value, list):
            list_values = ", ".join([f"'{v}'" for v in value])
            dart_code_lines.append(f"      {camel_case_key}: [{list_values}],\n")
        elif isinstance(value, bool):
            dart_code_lines.append(f"      {camel_case_key}: {str(value).lower()},\n")
        else:
            dart_code_lines.append(f"      {camel_case_key}: {value},\n")
    dart_code_lines.append("    ),\n")

dart_code_lines.append("  ];\n")
dart_code_lines.append("}\n")

# Join the lines into a single Dart code string and save it to a file
dart_code = ''.join(dart_code_lines)
output_file_path_camel_case = "/mnt/data/SpeakerModel_camelCase.dart"
with open(output_file_path_camel_case, "w", encoding="utf-8") as output_file:
    output_file.write(dart_code)

output_file_path_camel_case
