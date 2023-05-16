# wrappers for programming language installers
# npm, cargo, python pip, go 


# If the package is already installed, npm will not reinstall it. 
# wrapped in if statement as command produces noise if package is installed.
npm_install() {
local package=$1
 if ! command_exists "$package"; then
 npm install -g "$package"
 else
  dotsay "+ $package already installed... skipping."
 fi
   
}

pip_install() {
local package=$1
python3 -m pip install $package

}

# go_install() {

# }


# If the package is already installed, Cargo will not reinstall it. 
# Instead, it will print the following output:
# Package <package_name> is already installed.
cargo_install() {  
    local package=$1
	if ! command_exists "$package"; then
		cargo install $package
	fi
}