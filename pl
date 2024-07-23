import pandas as pd

def parse_log_file_to_dataframe(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    job_blocks = []
    current_block = None
    capture = False

    for i, line in enumerate(lines):
        if "sequence incremented" in line:
            job_id_line = lines[i + 1].strip()
            job_id = job_id_line.split(':')[1].strip()
            current_block = {'job_id': job_id, 'parameters': {}}
            capture = False
        elif "parameters to job" in line:
            capture = True
        elif capture:
            if "************" in line:
                capture = False
                job_blocks.append(current_block)
                current_block = None
            else:
                param_line = line.strip()
                if "=" in param_line:
                    param_name, param_value = param_line.split("=", 1)
                    current_block['parameters'][param_name.strip()] = param_value.strip()

    # Collect all unique parameter names
    all_parameters = set()
    for job in job_blocks:
        all_parameters.update(job['parameters'].keys())

    # Create a DataFrame
    df = pd.DataFrame(columns=[job['job_id'] for job in job_blocks], index=all_parameters)

    for job in job_blocks:
        job_id = job['job_id']
        for param_name, param_value in job['parameters'].items():
            df.at[param_name, job_id] = param_value

    df = df.fillna('')  # Fill NaN with empty strings for better display

    # Display the DataFrame
    import ace_tools as tools; tools.display_dataframe_to_user(name="Job Parameters DataFrame", dataframe=df)
    
    return df

# Example usage
df = parse_log_file_to_dataframe('path_to_your_log_file.log')
