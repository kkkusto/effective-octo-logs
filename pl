import re

def parse_log_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    job_blocks = []
    current_block = None
    capture = False

    for i, line in enumerate(lines):
        if "sequence incremented" in line:
            job_id_line = lines[i + 1].strip()
            job_id = job_id_line.split(':')[1].strip()
            current_block = {'job_id': job_id, 'parameters': []}
            capture = False
        elif "parameters to job" in line:
            capture = True
        elif capture:
            if "************" in line:
                capture = False
                job_blocks.append(current_block)
                current_block = None
            else:
                current_block['parameters'].append(line.strip())

    for job in job_blocks:
        print(f"Job ID: {job['job_id']}")
        print("Parameters:")
        for param in job['parameters']:
            print(param)
        print("************")

# Example usage
parse_log_file('path_to_your_log_file.log')
