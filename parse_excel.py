import pandas as pd
import glob

files = glob.glob(r'C:\Users\iamra\OneDrive\Desktop\DETAILS\*.xls*')
with open('schema_log.txt', 'w', encoding='utf-8') as f:
    for file in files:
        f.write(f'--- {file} ---\n')
        try:
            df = pd.read_excel(file)
            f.write(f"Columns: {df.columns.tolist()}\n")
            f.write("First Row:\n")
            f.write(str(df.head(1).to_dict('records')) + "\n\n")
            
            f.write("Row 100 (if exists):\n")
            if len(df) > 100:
                f.write(str(df.iloc[[100]].to_dict('records')) + "\n\n")
        except Exception as e:
            f.write(f'Error reading: {e}\n\n')
