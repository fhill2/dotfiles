# install a list of yay (pacman arch linux user repository), pip, npm, rust, golang packages. generalize the functionality to a single class. check if the package is installed before installing it. Only execute the installation command once. for every package manager instance, read a YAML file that contains a list of packages for that package manager only . provide a way to change the package manager command that retrieves the list of packages to install. include a callback function for every PackageManager instance that transforms the output of the command to retrieve the packages into a list of package names.

import subprocess
import yaml
import socket
import json
import os

# If python packages keep reinstalling as they are not detected by the comparison, 
# it means the pip package name in pip.yaml does not match the package name on pypi
# eg pip install python_graphql_client will install python-graphql-client


class PackageManager:
    def __init__(self, command, package_file, output_transformer=None):
        self.command = command
        self.package_files = package_file
        self.output_transformer = output_transformer

    def read_packages_from_yaml_files(self, package_files):
        packages = []
        for file in package_files:
            with open(file, 'r') as stream:
                try:
                    package_data = yaml.safe_load(stream)
                    if package_data:
                        packages.extend(package_data)
                except yaml.YAMLError as exc:
                    self.print_v(exc)
        return packages

    def print_v(self, msg):
        print("{}: {}".format(self.command[0], msg))

    def all_pkgs_lowercase(self, pkgs):
            return [pkg.lower() for pkg in pkgs]

        
    def install_packages(self):
        if not self.package_files:
            self.print_v("No package file provided.")
            return
            
        package_list = self.all_pkgs_lowercase(self.read_packages_from_yaml_files(self.package_files))

        # Check installed packages to prevent redundant installs
        installed_packages = self.all_pkgs_lowercase(set(self._get_installed_packages()))
        packages_to_install = [pkg for pkg in package_list if pkg not in installed_packages]
        # self.print_v("packages_to_install: " + repr(" ".join(packages_to_install)))
        # self.print_v("installed_packages: " + " ".join(installed_packages))
        if not packages_to_install:
            self.print_v("All packages already installed.")
            return

        self.print_v("Installing packages: {}".format(" ".join(packages_to_install)))
        
        # Install packages
        for pkg in packages_to_install:
            install_command = self.command + [pkg]
            subprocess.run(install_command, check=True)
            self.print_v(f"{pkg} installed successfully.")

        if self.command[0] == "pip": 
            exit()
        
    def _get_installed_packages(self):
        raise NotImplementedError
        
    def _transform_output(self, output):
        if self.output_transformer:
            return self.output_transformer(output)
        else:
            return output


class PacmanPackageManager(PackageManager):
    def __init__(self, package_files):
        super().__init__(["yay", "--noconfirm", "-S"], package_files)
        
    def _get_installed_packages(self):
        command = ["pacman", "-Qq"]  # List all installed packages
        output = subprocess.check_output(command).decode("utf-8")
        return output.splitlines()
    
    
class PipPackageManager(PackageManager):
    def __init__(self, package_files):
        super().__init__(["pip", "install"], package_files)
        
    def _get_installed_packages(self):
        command = ["pip", "freeze"]
        output = subprocess.check_output(command).decode("utf-8")
        return [line.split("==")[0] for line in output.splitlines()]
    
    
class NpmPackageManager(PackageManager):
    def __init__(self, package_files):
        super().__init__(["npm", "install", "-g"], package_files)
        
    def _get_installed_packages(self):
        command = ["npm", "ls", "-g", "--depth=0", "--json=true"]
        output = subprocess.check_output(command).decode("utf-8")
        return self._transform_output(output)


    def _transform_output(self, output):
        """receives json output from npm ls -g and parse"""
        json_obj = json.loads(output)
        dependencies = json_obj['dependencies']
        return list(dependencies.keys())
    
    
class RustPackageManager(PackageManager):
    def __init__(self, package_files):
        super().__init__(["cargo", "install"], package_files) 
        
    def _get_installed_packages(self):
        # command = ["cat", "~/.cargo", "--list"]
        # output = subprocess.check_output(command).decode("utf-8")
        json_file_path = f'{os.environ["HOME"]}/.cargo/.crates2.json'

        with open(json_file_path, 'r') as json_file:
            json_data = json.load(json_file)

# Convert JSON data to Python dictionary
        data_dict = dict(json_data)['installs']
        pkgs = []
        for key in data_dict.keys():
            pkgs.append(key.split(" ")[0])
        return pkgs
    

# incomplete
# class GolangPackageManager(PackageManager):
#     def __init__(self, package_files):
#         super().__init__(["go", "get"], package_files)
#         
#     def _get_installed_packages(self):
#         command = ["go", "list", "..."]
#         output = subprocess.check_output(command).decode("utf-8")
#         return output.strip().splitlines()


# Example usage    
if __name__ == "__main__":
    
    # get hostname
    # # pacman_manager = PacmanPackageManager(["pacman.yaml", "pacman_{}.yaml".format(socket.gethostname())])
    # pacman_manager.install_packages()
    # --needed -> do not install package if already installed
    
    pip_manager = PipPackageManager(["pip.yaml"])
    pip_manager.install_packages()
    
    npm_manager = NpmPackageManager(["npm.yaml"])
    npm_manager.install_packages()
    
    rust_manager = RustPackageManager(["cargo.yaml"])
    rust_manager.install_packages()
    
    # golang_manager = GolangPackageManager(["go.yaml"])
    # golang_manager.install_packages()
    
    # To change the command that retrieves the package list for a specific manager:
    pacman_manager.command = ["yay", "--needed", "--noconfirm", "-Sl", "my-repo"]  # list from my-repo only
    pip_manager.command = ["pip", "list", "--outdated"]  # list only outdated packages
    






