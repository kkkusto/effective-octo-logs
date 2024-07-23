import pandas as pd

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

    all_jobs_data = []
    for job in job_blocks:
        job_id = job['job_id']
        parameters = job['parameters']
        job_data = {'job_id': [], 'parameter': [], 'value': []}
        
        for param in parameters:
            if '=' in param:
                key, value = param.split('=', 1)
                job_data['job_id'].append(job_id)
                job_data['parameter'].append(key.strip())
                job_data['value'].append(value.strip())
        
        job_df = pd.DataFrame(job_data)
        all_jobs_data.append(job_df)
    
    # Merge all job DataFrames into a single DataFrame
    if all_jobs_data:
        final_df = pd.concat(all_jobs_data, ignore_index=True)
    else:
        final_df = pd.DataFrame(columns=['job_id', 'parameter', 'value'])

    return final_df

# Example usage
file_path = 'path_to_your_log_file.log'
final_df = parse_log_file(file_path)
import ace_tools as tools; tools.display_dataframe_to_user(name="Merged Job Parameters", dataframe=final_df)
