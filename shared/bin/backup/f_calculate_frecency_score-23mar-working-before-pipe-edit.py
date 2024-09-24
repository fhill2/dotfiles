#!/usr/bin/python

import sqlite3


# connection object
# 1st arg - file to store data, or in memory database
conn = sqlite3.connect('/home/f1/.local/share/nvim/file_frecency.sqlite3')
c = conn.cursor()




#c.execute("SELECT * FROM files WHERE path='/home/f1/dev/cl/lua/standalone/codelibrary/data/symlinks.lua'")
#print(c.fetchone())





def file_get_entries():
  c.execute("""
  SELECT * from files
  """)
  table = c.fetchall()

  items = []
  for i, row in enumerate(table):
    items.append({
      'count': row[0],
      'id': row[1],
      'path': row[2] 
    })
  return items
    


def timestamp_get_all_entry_ages():
  c.execute("""
  SELECT id, file_id, CAST((julianday('now') - julianday(timestamp)) * 24 * 60 AS INTEGER) AS age FROM timestamps;
  """)
  table = c.fetchall()

  items = []
  for i, row in enumerate(table):
    items.append({
      'age': row[2],
      'file_id': row[1],
      'id': row[0], 
    })
        #items[i]['age'] = items[i]['age'] + 1
  return items
  

#import sys
#data = sys.stdin.readlines()
#print "Counted", len(data), "lines."

MAX_TIMESTAMPS = 10

recency_modifier = [
    { 'age': 240, 'value': 100 }, # past 4 hours
    { 'age': 1440  , 'value': 80  }, # past day
    { 'age': 4320  , 'value': 60  }, # past 3 days
    { 'age': 10080 , 'value': 40  }, # past week
    { 'age': 43200 , 'value': 20  }, # past month
    { 'age': 129600, 'value': 10  }  # past 90 days
]

def calculate_inner_file_score(ts, recency_score):
  for _, rank in enumerate(recency_modifier):
    if ts["age"] <= rank["age"]:
      return recency_score + rank["value"]


def calculate_file_score(frequency, timestamps):
  recency_score = 0
  for _, ts in enumerate(timestamps):
    recency_score = calculate_inner_file_score(ts, recency_score) or 0
  return frequency * recency_score / MAX_TIMESTAMPS


def filter_timestamps(timestamps, file_id):
  res = []
  for i, entry in enumerate(timestamps):
    if entry["file_id"] == file_id:
      res.append(entry)
  return res

def get_file_scores(): 
  timestamp_ages = timestamp_get_all_entry_ages()
  files = file_get_entries()

  scores = []
  for i, file_entry in enumerate(files):
    score = calculate_file_score(file_entry["count"], filter_timestamps(timestamp_ages, file_entry["id"]))
    scores.append({
      'filename': file_entry["path"],
      'score': score
    })

  return scores

get_file_scores()


