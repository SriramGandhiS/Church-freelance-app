import openpyxl, xlrd, csv, sys, os

def read_xlsx(path):
    wb = openpyxl.load_workbook(path, data_only=True)
    ws = wb.active
    rows = list(ws.values)
    return rows

def read_xls(path):
    wb = xlrd.open_workbook(path)
    ws = wb.sheet_by_index(0)
    rows = [ws.row_values(i) for i in range(ws.nrows)]
    return rows

def rows_to_dicts(rows, src_name):
    if not rows:
        return [], []
    header = [str(h).strip() if h else '' for h in rows[0]]
    print(f"[{src_name}] Columns: {header}", file=sys.stderr)
    result = []
    for row in rows[1:]:
        cells = [str(c).strip() if c is not None else '' for c in row]
        # Pad cells to match header length
        while len(cells) < len(header):
            cells.append('')
        d = dict(zip(header, cells[:len(header)]))
        if any(v != '' for v in d.values()):
            result.append(d)
    return result, header

f1 = 'assets/data/pastors_tn752.xlsx'
f2 = 'assets/data/pastors_tn833.xls'

data1, h1 = rows_to_dicts(read_xlsx(f1), 'tn752') if os.path.exists(f1) else ([], [])
data2, h2 = rows_to_dicts(read_xls(f2), 'tn833') if os.path.exists(f2) else ([], [])

# Merge using the union of all headers
all_keys = list(dict.fromkeys(h1 + [k for k in h2 if k not in h1]))

all_data = data1 + data2

with open('assets/data/pastors.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=all_keys, extrasaction='ignore')
    writer.writeheader()
    for row in all_data:
        writer.writerow({k: row.get(k, '') for k in all_keys})

print(f"Total records: {len(all_data)}")
if all_data:
    print("Sample keys:", list(all_data[0].keys())[:8])
    print("First record:", {k: all_data[0].get(k,'') for k in list(all_data[0].keys())[:8]})
