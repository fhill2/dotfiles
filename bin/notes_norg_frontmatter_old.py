import osimport frontmatter
from frontmatter.default_handlers import YAMLHandler, BaseHandler

# /usr/lib/python3.10/site-packages/
class NORGHandler(BaseHandler):
    START_DELIMITER = "@document.meta"
    END_DELIMITER = "@end"
frontmatter.loads()



class FrontMatter:
    def __init__(self, abs):
        self.abs = abs

        # frontmatter data
        self.line_end = None
        self.metadata = {}

        self.parse()

    def decide_format(self):
        for line in self.content:
            if line.strip() == "@document.meta":
                self.type = "norg"
                return
            elif line.strip() == "---":
                self.type = "yaml"
                return
            else:
                self.type = "unknown"
                return

    def parse(self):
        # read content of file
        f = open(self.abs, "r+")
        self.content = f.readlines()
        f.close()

        self.decide_format()
        self.error_if_type_unknown()
            
        parse = {
            "norg": self.parse_norg,
            "yaml": self.parse_yaml
        }
        parse[self.type]()

    def parse_yaml(self):
        self.error_if_type_unknown()
        self.metadata = frontmatter.load(self.abs)

    def generate_post():
        """generates python-frontmatter post class object from the norg parsed metadata"""


    def write_yaml(self):
        post = frontmatter.Post("some content here asd", YAMLHandler(), tagyespls="asd")
        with open(self.abs, "w") as f:
            f.write(frontmatter.dumps(post))
        f.close()
            #{"tagsyespls": ["asd1", "asd2"]}))

    # def write_yaml(self):
    #     if self.type == "norg":
    #         self.metadata = frontmatter.loads(self.convert_frontmatter_to_string())
    #
    #     with open(self.abs, "r+") as f:
    #         f.write(frontmatter.dumps(self.metadata))
    #     f.close()

    def parse_norg_kv(self, line):
        split = line.split(':')
        k = split[0]
        v = split[1].strip()
        v = split[1].split(" ") if " " in v else v
        v = ' '.join(v).split() if isinstance(v, list) else v # remove empty strings from list
        return k, v

    def parse_norg(self):
        self.error_if_type_unknown()
        start_parser = False
        linenr = 0
        for line in self.content:
            line = line.strip()
            if line == "@end":
                self.line_end = linenr
                linenr = linenr + 1
                break
            if line == "@document.meta":
                start_parser = True
                linenr = linenr + 1
                continue

            if start_parser:
                k, v = self.parse_norg_kv(line)
                linenr = linenr + 1
                self.metadata[k] = v

    def error_if_type_unknown(self):
        if self.type == "unknown":
            print("frontmatter type is unknown - unable to parse")
            exit()



    def write(self):
        self.error_if_type_unknown()
        write = {
            "norg": self.write_norg,
            # "yaml": self.write_yaml,
        }
        write[self.type]()
 
    # def convert_frontmatter_to_string(self):
    #     """converts norg frontmatter existing within self.metadata dict to a yaml frontmatter string representation"""
    #     """the result is loaded into python-frontmatter parser so the norg frontmatter can be written to the file using the python-frontmatter library"""
    #     self.error_if_type_unknown()
    #     lines = ['---']
    #     for [k,v] in self.metadata.items():
    #         print(k, v)
    #         if isinstance(v, list):
    #             lines.append(k + ": [" + ", ".join(v) + "]")
    #         else:
    #             lines.append(k + ": " + v)
    #     lines.append('---')
    #     return "\n".join(lines)
    #
    #

### OLD
### MIGHT NEED THESE FUNCTIONS TO GO FROM YAML -> NEORG
    # def prepend(self, lines):
    #     """writes lines to beginning of file - used to write frontmatter"""
    #     with open(self.abs, "r+") as f:
    #         old = f.read() # read everything in the file
    #         f.seek(0)
    #         for line in lines:
    #             f.write(line)
    #             f.write("\n")
    #         f.write(old)
    #     f.close()
    #
    #
    # def _delete_frontmatter(self):
    #     self.error_if_type_unknown()
    #
    #     """In a file, delete the lines at line number in given list"""
    #     is_skipped = False
    #     counter = 0
    #     # Create name of dummy / temporary file
    #     dummy_file = self.abs + '.bak'
    #     # Open original file in read only mode and dummy file in write mode
    #     with open(self.abs, 'r') as read_obj, open(dummy_file, 'w') as write_obj:
    #         # Line by line copy data from original file to dummy file
    #         for line in read_obj:
    #             # If current line number exist in list then skip copying that line
    #             if counter not in [num for num in range(0, self.line_end + 1)]:
    #                 write_obj.write(line)
    #             else:
    #                 is_skipped = True
    #             counter += 1
    #
    #     # If any line is skipped then rename dummy file as original file
    #     if is_skipped:
    #         os.remove(self.abs)
    #         os.rename(dummy_file, self.abs)
    #     else:
    #         os.remove(dummy_file) 


