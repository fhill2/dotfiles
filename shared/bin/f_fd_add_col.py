#!/usr/bin/python

def log(*args, **kwargs):
    f = open("/home/f1/logs/python.log",'w')
    print(*args, **kwargs, file=f)
    f.close()



def dump(obj):
    import inspect
    x = []
    printl("===================== methods ====================")
    for i in inspect.getmembers(obj):
        if not i[0].startswith('_'):
            if not inspect.ismethod(i[1]):
                x.append(i)
            else:
                printl(i)
    printl("===================== props ====================")
    for props in x:
        printl(props)


# ========= FRECENCY ==========
import sqlite3
conn = sqlite3.connect('/home/f1/.local/share/nvim/file_frecency.sqlite3')
c = conn.cursor()

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
  return round(frequency * recency_score / MAX_TIMESTAMPS)


def filter_timestamps(timestamps, file_id):
  res = []
  for i, entry in enumerate(timestamps):
    if entry["file_id"] == file_id:
      res.append(entry)
  return res

def get_file_scores(): 
  timestamp_ages = timestamp_get_all_entry_ages()
  files = file_get_entries()

  scores = {}
  for i, file_entry in enumerate(files):
    path = file_entry["path"]
    score = calculate_file_score(file_entry["count"], filter_timestamps(timestamp_ages, file_entry["id"]))
    # original
    # scores.append({
    #   'filename': file_entry["path"],
    #   'score': score
    # })
    scores[path] = score

  return scores

scores = get_file_scores()



# ========= ICONS ==========
# nvim-web-devicons
from slpp import slpp as lua
DEVICONS = lua.decode("""
{
  [".babelrc"] = {
    icon = "ﬥ",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Babelrc",
  },
  [".bash_profile"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "BashProfile",
  },
  [".bashrc"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Bashrc",
  },
  [".ds_store"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "DsStore",
  },
  [".gitattributes"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitAttributes",
  },
  [".gitconfig"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitConfig",
  },
  [".gitignore"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitIgnore",
  },
  [".gitlab-ci.yml"] = {
    icon = "",
    color = "#e24329",
    cterm_color = "166",
    name = "GitlabCI",
  },
  [".gitmodules"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitModules",
  },
  [".gvimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Gvimrc",
  },
  [".npmignore"] = {
    icon = "",
    color = "#E8274B",
    cterm_color = "161",
    name = "NPMIgnore",
  },
  [".npmrc"] = {
    icon = "",
    color = "#E8274B",
    cterm_color = "161",
    name = "NPMrc",
  },
  [".settings.json"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "SettingsJson",
  },
  [".vimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Vimrc",
  },
  [".zprofile"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshprofile",
  },
  [".zshenv"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshenv",
  },
  [".zshrc"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zshrc",
  },
  ["Brewfile"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Brewfile",
  },
  ["CMakeLists.txt"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "CMakeLists",
  },
  ["COMMIT_EDITMSG"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "GitCommit",
  },
  ["COPYING"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  ["COPYING.LESSER"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  ["Dockerfile"] = {
    icon = "",
    color = "#384d54",
    cterm_color = "59",
    name = "Dockerfile",
  },
  ["Gemfile$"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Gemfile",
  },
  ["LICENSE"] = {
    icon = "",
    color = "#d0bf41",
    cterm_color = "179",
    name = "License",
  },
  ["R"] = {
    icon = "ﳒ",
    color = "#358a5b",
    cterm_color = "65",
    name = "R",
  },
  ["Rmd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Rmd",
  },
  ["Vagrantfile$"] = {
    icon = "",
    color = "#1563FF",
    cterm_color = "27",
    name = "Vagrantfile",
  },
  ["_gvimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Gvimrc",
  },
  ["_vimrc"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Vimrc",
  },
  ["ai"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ai",
  },
  ["awk"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Awk",
  },
  ["bash"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Bash",
  },
  ["bat"] = {
    icon = "",
    color = "#C1F12E",
    cterm_color = "154",
    name = "Bat",
  },
  ["bmp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Bmp",
  },
  ["c"] = {
    icon = "",
    color = "#599eff",
    cterm_color = "75",
    name = "C",
  },
  ["c++"] = {
    icon = "",
    color = "#f34b7d",
    cterm_color = "204",
    name = "CPlusPlus",
  },
  ["cbl"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cc"] = {
    icon = "",
    color = "#f34b7d",
    cterm_color = "204",
    name = "CPlusPlus",
  },
  ["cfg"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "231",
    name = "Configuration",
  },
  ["clj"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "107",
    name = "Clojure",
  },
  ["cljc"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "107",
    name = "ClojureC",
  },
  ["cljs"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "ClojureJS",
  },
  ["cmake"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "CMake",
  },
  ["cob"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cobol"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["coffee"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Coffee",
  },
  ["conf"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Conf",
  },
  ["config.ru"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "ConfigRu",
  },
  ["cp"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Cp",
  },
  ["cpp"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Cpp",
  },
  ["cpy"] = {
    icon = "⚙",
    color = "#005ca5",
    cterm_color = "25",
    name = "Cobol",
  },
  ["cr"] = {
    icon = "",
    color = "#000000",
    cterm_color = "16",
    name = "Crystal",
  },
  ["cs"] = {
    icon = "",
    color = "#596706",
    cterm_color = "58",
    name = "Cs",
  },
  ["csh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Csh",
  },
  ["cson"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Cson",
  },
  ["css"] = {
    icon = "",
    color = "#563d7c",
    cterm_color = "60",
    name = "Css",
  },
  ["csv"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Csv",
  },
  ["cxx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Cxx",
  },
  ["d"] = {
    icon = "",
    color = "#427819",
    cterm_color = "64",
    name = "D",
  },
  ["dart"] = {
    icon = "",
    color = "#03589C",
    cterm_color = "25",
    name = "Dart",
  },
  ["db"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Db",
  },
  ["desktop"] = {
    icon = "",
    color = "#563d7c",
    cterm_color = "60",
    name = "DesktopEntry",
  },
  ["diff"] = {
    icon = "",
    color = "#41535b",
    cterm_color = "59",
    name = "Diff",
  },
  ["doc"] = {
    icon = "",
    color = "#185abd",
    cterm_color = "25",
    name = "Doc",
  },
  ["dockerfile"] = {
    icon = "",
    color = "#384d54",
    cterm_color = "59",
    name = "Dockerfile",
  },
  ["dropbox"] = {
    icon = "",
    color = "#0061FE",
    cterm_color = "27",
    name = "Dropbox",
  },
  ["dump"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Dump",
  },
  ["edn"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Edn",
  },
  ["eex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Eex",
  },
  ["ejs"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ejs",
  },
  ["elm"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Elm",
  },
  ["epp"] = {
    icon = "",
    color = "#FFA61A",
    name = "Epp",
  },
  ["erb"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Erb",
  },
  ["erl"] = {
    icon = "",
    color = "#B83998",
    cterm_color = "132",
    name = "Erl",
  },
  ["ex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Ex",
  },
  ["exs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Exs",
  },
  ["f#"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fsharp",
  },
  ["favicon.ico"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Favicon",
  },
  ["fish"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Fish",
  },
  ["fs"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fs",
  },
  ["fsi"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fsi",
  },
  ["fsscript"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fsscript",
  },
  ["fsx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Fsx",
  },
  ["gd"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "GDScript",
  },
  ["gemspec"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Gemspec",
  },
  ["gif"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Gif",
  },
  ["git"] = {
    icon = "",
    color = "#F14C28",
    cterm_color = "202",
    name = "GitLogo",
  },
  ["glb"] = {
    icon = "",
    color = "#FFB13B",
    cterm_color = "215",
    name = "BinaryGLTF",
  },
  ["go"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Go",
  },
  ["godot"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "GodotProject",
  },
  ["gruntfile"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "Gruntfile",
  },
  ["gulpfile"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Gulpfile",
  },
  ["h"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "H",
  },
  ["haml"] = {
    icon = "",
    color = "#eaeae1",
    cterm_color = "188",
    name = "Haml",
  },
  ["hbs"] = {
    icon = "",
    color = "#f0772b",
    cterm_color = "208",
    name = "Hbs",
  },
  ["heex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Heex",
  },
  ["hh"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hh",
  },
  ["hpp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hpp",
  },
  ["hrl"] = {
    icon = "",
    color = "#B83998",
    cterm_color = "132",
    name = "Hrl",
  },
  ["hs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hs",
  },
  ["htm"] = {
    icon = "",
    color = "#e34c26",
    cterm_color = "166",
    name = "Htm",
  },
  ["html"] = {
    icon = "",
    color = "#e34c26",
    cterm_color = "166",
    name = "Html",
  },
  ["hxx"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Hxx",
  },
  ["ico"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Ico",
  },
  ["import"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "231",
    name = "ImportConfiguration",
  },
  ["ini"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Ini",
  },
  ["java"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Java",
  },
  ["jl"] = {
    icon = "",
    color = "#a270ba",
    cterm_color = "133",
    name = "Jl",
  },
  ["jpeg"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Jpeg",
  },
  ["jpg"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Jpg",
  },
  ["js"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Js",
  },
  ["json"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "Json",
  },
  ["jsx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Jsx",
  },
  ["ksh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Ksh",
  },
  ["kt"] = {
    icon = "𝙆",
    color = "#F88A02",
    cterm_color = "208",
    name = "Kotlin",
  },
  ["leex"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Leex",
  },
  ["less"] = {
    icon = "",
    color = "#563d7c",
    cterm_color = "60",
    name = "Less",
  },
  ["lhs"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Lhs",
  },
  ["license"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "License",
  },
  ["lua"] = {
    icon = "",
    color = "#51a0cf",
    cterm_color = "74",
    name = "Lua",
  },
  ["makefile"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Makefile",
  },
  ["markdown"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Markdown",
  },
  ["material"] = {
    icon = "",
    color = "#B83998",
    cterm_color = "132",
    name = "Material",
  },
  ["md"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Md",
  },
  ["mdx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Mdx",
  },
  ["mint"] = {
    icon = "",
    color = "#87c095",
    cterm_color = "108",
    name = "Mint",
  },
  ["mix.lock"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "MixLock",
  },
  ["mjs"] = {
    icon = "",
    color = "#f1e05a",
    cterm_color = "221",
    name = "Mjs",
  },
  ["ml"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "173",
    name = "Ml",
  },
  ["mli"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "173",
    name = "Mli",
  },
  ["mustache"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "Mustache",
  },
  ["nim"] = {
    icon = "👑",
    color = "#f3d400",
    cterm_color = "220",
    name = "Nim",
  },
  ["nix"] = {
    icon = "",
    color = "#7ebae4",
    cterm_color = "110",
    name = "Nix",
  },
  ["node_modules"] = {
    icon = "",
    color = "#E8274B",
    cterm_color = "161",
    name = "NodeModules",
  },
  ["opus"] = {
    icon = "",
    color = "#F88A02",
    cterm_color = "208",
    name = "OPUS",
  },
  ["otf"] = {
    icon = "",
    color = "#ECECEC",
    cterm_color = "231",
    name = "OpenTypeFont",
  },
  ['package.json'] = {
    icon = "",
    color = "#e8274b",
    name = "PackageJson"
  },
  ['package-lock.json'] = {
    icon = "",
    color = "#7a0d21",
    name = "PackageLockJson"
  },
  ["pck"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "PackedResource",
  },
  ["pdf"] = {
    icon = "",
    color = "#b30b00",
    cterm_color = "124",
    name = "Pdf",
  },
  ["php"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Php",
  },
  ["pl"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Pl",
  },
  ["pm"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Pm",
  },
  ["png"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Png",
  },
  ["pp"] = {
    icon = "",
    color = "#FFA61A",
    name = "Pp",
  },
  ["ppt"] = {
    icon = "",
    color = "#cb4a32",
    cterm_color = "167",
    name = "Ppt",
  },
  ["pro"] = {
    icon = "",
    color = "#e4b854",
    cterm_color = "179",
    name = "Prolog",
  },
  ["procfile"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Procfile",
  },
  ["ps1"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "PromptPs1",
  },
  ["psb"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Psb",
  },
  ["psd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Psd",
  },
  ["py"] = {
    icon = "",
    color = "#ffbc03",
    cterm_color = "61",
    name = "Py",
  },
  ["pyc"] = {
    icon = "",
    color = "#ffe291",
    cterm_color = "67",
    name = "Pyc",
  },
  ["pyd"] = {
    icon = "",
    color = "#ffe291",
    cterm_color = "67",
    name = "Pyd",
  },
  ["pyo"] = {
    icon = "",
    color = "#ffe291",
    cterm_color = "67",
    name = "Pyo",
  },
  ["r"] = {
    icon = "ﳒ",
    color = "#358a5b",
    cterm_color = "65",
    name = "R",
  },
  ["rake"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rake",
  },
  ["rakefile"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rakefile",
  },
  ["rb"] = {
    icon = "",
    color = "#701516",
    cterm_color = "52",
    name = "Rb",
  },
  ["rlib"] = {
    icon = "",
    color = "#dea584",
    cterm_color = "180",
    name = "Rlib",
  },
  ["rmd"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Rmd",
  },
  ["rproj"] = {
    icon = "鉶",
    color = "#358a5b",
    cterm_color = "65",
    name = "Rproj",
  },
  ["rs"] = {
    icon = "",
    color = "#dea584",
    cterm_color = "180",
    name = "Rs",
  },
  ["rss"] = {
    icon = "",
    color = "#FB9D3B",
    cterm_color = "215",
    name = "Rss",
  },
  ["sass"] = {
    icon = "",
    color = "#f55385",
    cterm_color = "204",
    name = "Sass",
  },
  ["scala"] = {
    icon = "",
    color = "#cc3e44",
    cterm_color = "167",
    name = "Scala",
  },
  ["scss"] = {
    icon = "",
    color = "#f55385",
    cterm_color = "204",
    name = "Scss",
  },
  ["sh"] = {
    icon = "",
    color = "#4d5a5e",
    cterm_color = "59",
    name = "Sh",
  },
  ["sig"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "173",
    name = "Sig",
  },
  ["slim"] = {
    icon = "",
    color = "#e34c26",
    cterm_color = "166",
    name = "Slim",
  },
  ["sln"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "Sln",
  },
  ["sml"] = {
    icon = "λ",
    color = "#e37933",
    cterm_color = "173",
    name = "Sml",
  },
  ["sql"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Sql",
  },
  ["sqlite"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Sql",
  },
  ["sqlite3"] = {
    icon = "",
    color = "#dad8d8",
    cterm_color = "188",
    name = "Sql",
  },
  ["styl"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "107",
    name = "Styl",
  },
  ["sublime"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "98",
    name = "Suo",
  },
  ["suo"] = {
    icon = "",
    color = "#854CC7",
    cterm_color = "98",
    name = "Suo",
  },
  ["svelte"] = {
    icon = "",
    color = "#ff3e00",
    cterm_color = "202",
    name = "Svelte",
  },
  ["svg"] = {
    icon = "ﰟ",
    color = "#FFB13B",
    cterm_color = "215",
    name = "Svg",
  },
  ["swift"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "Swift",
  },
  ["t"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Tor",
  },
  ["terminal"] = {
    icon = "",
    color = "#31B53E",
    cterm_color = "71",
    name = "Terminal",
  },
  ["tex"] = {
    icon = "ﭨ",
    color = "#3D6117",
    cterm_color = "58",
    name = "Tex",
  },
  ["toml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Toml",
  },
  ["tres"] = {
    icon = "",
    color = "#cbcb41",
    cterm_color = "185",
    name = "TextResource",
  },
  ["ts"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Ts",
  },
  ["tscn"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "TextScene",
  },
  ["tsx"] = {
    icon = "",
    color = "#519aba",
    cterm_color = "67",
    name = "Tsx",
  },
  ["twig"] = {
    icon = "",
    color = "#8dc149",
    cterm_color = "107",
    name = "Twig",
  },
  ["txt"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Txt",
  },
  ["vim"] = {
    icon = "",
    color = "#019833",
    cterm_color = "29",
    name = "Vim",
  },
  ["vue"] = {
    icon = "﵂",
    color = "#8dc149",
    cterm_color = "107",
    name = "Vue",
  },
  ["webmanifest"] = {
    icon = "",
    color = "#f1e05a",
    cterm_color = "221",
    name = "Webmanifest",
  },
  ["webp"] = {
    icon = "",
    color = "#a074c4",
    cterm_color = "140",
    name = "Webp",
  },
  ["webpack"] = {
    icon = "ﰩ",
    color = "#519aba",
    cterm_color = "67",
    name = "Webpack",
  },
  ["xcplayground"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "XcPlayground",
  },
  ["xls"] = {
    icon = "",
    color = "#207245",
    cterm_color = "23",
    name = "Xls",
  },
  ["xml"] = {
    icon = "謹",
    color = "#e37933",
    cterm_color = "173",
    name = "Xml",
  },
  ["xul"] = {
    icon = "",
    color = "#e37933",
    cterm_color = "173",
    name = "Xul",
  },
  ["yaml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Yaml",
  },
  ["yml"] = {
    icon = "",
    color = "#6d8086",
    cterm_color = "66",
    name = "Yml",
  },
  ["zig"] = {
    icon = "",
    color = "#f69a1b",
    cterm_color = "208",
    name = "Zig",
  },
  ["zsh"] = {
    icon = "",
    color = "#89e051",
    cterm_color = "113",
    name = "Zsh",
  },
}
""")

default_icon = {
    "icon": "",
    "color": "#6d8086",
    "cterm_color": "66",
    "name": "Default",
}

dir_icon = {
    "icon": "",
    "color": "#0087af",
    "cterm_color": "31",
    "name": "Dir",
}

# ===== TIME DATE =====
def time_format(seconds: int):
    if seconds is not None:
        seconds = int(seconds)
        d = seconds // (3600 * 24)
        h = seconds // 3600 % 24
        m = seconds % 3600 // 60
        s = seconds % 3600 % 60
        if d > 0:
            return '{:02d}D {:02d}H {:02d}m {:02d}s'.format(d, h, m, s)
        elif h > 0:
            return '{:02d}H {:02d}m {:02d}s'.format(h, m, s)
        elif m > 0:
            return '{:02d}m {:02d}s'.format(m, s)
        elif s > 0:
            return '{:02d}s'.format(s)
    return '-'

# MAIN LOOP
import sys
import os
from os import path
from os.path import expanduser

log("========== SCRIPT STARTUP ===========")
for line in sys.stdin:
  line = str(line.strip())
  line = ' '.join(line.split())
  ll = line.partition(" ")
  modified = ll[0]
  fp = ll[2]
  out = fp
  

  if path.isfile(fp):
    (_, filename) = os.path.split(fp)
    (_, ext) = path.splitext(filename)
    try:
      devicon = DEVICONS[ext.replace(".", "")]
    except KeyError:
      try:
         devicon = DEVICONS[filename]
      except KeyError:
         devicon = default_icon
  elif path.isdir(fp):
    devicon = dir_icon
  else:
    devicon = default_icon
  
  # some icons dont have a cterm color
  if "cterm_color" not in devicon:
    devicon["cterm_color"] = 66

      
  icon = '\033[38;5;%sm%s\033[0m' % (devicon["cterm_color"], devicon["icon"])

      

  
    # res = subprocess.check_output(['stat', '--printf=%Y', fp])
    # for line in res.splitlines():
    #   seconds = str(line.strip())
    #   seconds = time_format(int(seconds.replace(seconds[:1], "").replace("'", "")))
 

    
  out = icon + " " + out
  # append frecency score
  #home = expanduser("~")

  # always make frecency path lookup absolute path, even if relative input
  if not path.isabs(fp):
    abs_fp = path.abspath(fp)
  else:
    abs_fp = fp

  if abs_fp in scores:
    out = str(scores[abs_fp]) + " " + out
  else:
    out = "0 " + out


  if 'modified' in locals():
    out = modified + " " + out


  print(out)
