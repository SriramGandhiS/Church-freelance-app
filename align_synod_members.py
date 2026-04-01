import pandas as pd
import glob
import os

files = glob.glob(r'C:\Users\iamra\OneDrive\Desktop\DETAILS\*.xls*')

all_data = []

# Columns exactly as we want them in the Google Sheet 
target_columns = [
    'Reg_No', 'Name', 'Designation', 'Office', 'DOB', 
    'Phone', 'Email', 'Address', 'Church_Name', 
    'District', 'State', 'Date_of_Ordination', 'Status'
]

for file in files:
    try:
        df = pd.read_excel(file)
        print(f"Reading {os.path.basename(file)}...")
        
        # Determine actual column names, ignoring exact whitespace
        columns = df.columns.tolist()
        col_map = {str(c).strip(): c for c in columns}
        
        # Create a new blank df mapping our targets
        clean_df = pd.DataFrame()
        
        clean_df['Reg_No'] = df[col_map.get('Reg.No', 'Reg.No')] if col_map.get('Reg.No') else ''
        clean_df['Name'] = df[col_map.get('Name', 'Name')] if col_map.get('Name') else ''
        clean_df['Designation'] = df[col_map.get('Designation', 'Designation')] if col_map.get('Designation') else ''
        clean_df['Office'] = df[col_map.get('Office', 'Office')] if col_map.get('Office') else ''
        clean_df['DOB'] = df[col_map.get('D.O.B', 'D.O.B')] if col_map.get('D.O.B') else ''
        clean_df['Phone'] = df[col_map.get('Phone No.', 'Phone No.')] if col_map.get('Phone No.') else ''
        clean_df['Email'] = df[col_map.get('E-mail Address', 'E-mail Address')] if col_map.get('E-mail Address') else ''
        clean_df['Address'] = df[col_map.get('Contact Address', 'Contact Address')] if col_map.get('Contact Address') else ''
        clean_df['Church_Name'] = df[col_map.get('Church Name', 'Church Name')] if col_map.get('Church Name') else ''
        clean_df['District'] = df[col_map.get('District', 'District')] if col_map.get('District') else ''
        
        # The 'State' column might be empty strings or 'State'
        state_col = col_map.get('State')
        if not state_col:
            # Look for the empty string column in that specific file
            empty_cols = [c for c in columns if str(c).strip() == '']
            if empty_cols:
                state_col = empty_cols[0]
        clean_df['State'] = df[state_col] if state_col else ''
        
        clean_df['Date_of_Ordination'] = df[col_map.get('Date of Ordination', 'Date of Ordination')] if col_map.get('Date of Ordination') else ''
        clean_df['Status'] = df[col_map.get('Status', 'Status')] if col_map.get('Status') else ''
        
        all_data.append(clean_df)
    except Exception as e:
        print(f"Error processing {file}: {e}")

if all_data:
    final_df = pd.concat(all_data, ignore_index=True)
    # Forward fill or clean any entirely NaN rows if needed
    final_df = final_df.dropna(subset=['Name', 'Reg_No'], how='all')
    
    # Save the aligned file directly to the desktop details folder
    output_path = r'C:\Users\iamra\OneDrive\Desktop\DETAILS\Cleaned_Synod_Members.csv'
    final_df.to_csv(output_path, index=False)
    print(f"\nSUCCESS! Created aligned file at: {output_path}")
