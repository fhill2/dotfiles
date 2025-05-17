# to run tests, this cmd has to be run in this test file's directory:
# sudo apt install bats
# --> bats test.bats

# 17th May 2025 TODO:
# Test the symlink script can auto delete broken symlinks that exist in locations that require root permissions

setup_file() {
    # executes once per test run 
    # echo does not show any output
    # all variables need to be exported so they can be accessed within the scope of the tests
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"
    export PATH
}

setup() {
  load '/usr/lib/bats/bats-support/load.bash'
  load '/usr/lib/bats/bats-assert/load.bash'
}


@test "source file exists, meets below requirements, succeed" {
    source_file="$(mktemp)"
    dest_directory="$(mktemp -d)"
    source_name="$(basename "$source_file")"
    run _symlink "$source_file" "$dest_directory/$source_name"
    assert_success
}


@test "source directory exists, meets below requirements, succeed" {
    source_directory="$(mktemp -d)"
    dest_directory="$(mktemp -d)"
    source_name="$(basename "$source_directory")"
    echo "$source_name"
    run _symlink "$source_directory" "$dest_directory/$source_name"
    assert_success

}

@test "source executable exists, meets below requirements, succeed" {
    source_exe="$(mktemp)"
    dest_directory="$(mktemp -d)"
    chmod +x "$source_exe"
    source_name="$(basename "$source_exe")"
    run _symlink "$source_exe" "$dest_directory/$source_name"
    assert_success
}

@test "source file/folder/executable does not exist, fail" {
    source_path="/tmp/non-existant-source-path"
    dest_directory="$(mktemp -d)"
    source_name="$(basename "$source_path")"
    run _symlink "$source_path" "$dest_directory/$source_name"
    assert_failure
}

@test "destination dir exists, source exists, fail" {
    source_directory="$(mktemp -d)"
    dest_directory="$(mktemp -d)"
    run _symlink "$source_directory" "$dest_directory"
    echo "$output"
    assert_failure
}
@test "destination file exists, source exists, fail" {
    source_file="$(mktemp)"
    dest_file="$(mktemp)"
    run _symlink "$source_file" "$dest_file"
    assert_failure
}
@test "destination exe exists, source exists, fail" {
    source_exe="$(mktemp)"
    dest_exe="$(mktemp)"
    chmod +x "$dest_exe"
    run _symlink "$source_exe" "$dest_exe"
    assert_failure
}

@test "destination sym exists, source exists, dereferenced destination sym links to source, succeed (noop)" {
    source_file="$(mktemp)"
    rm -f "/tmp/test_symlink"
    ln -s "$source_file" "/tmp/test_symlink"
    run _symlink "$source_file" "/tmp/test_symlink"
    assert_success
}
#
@test "destination sym exists, source exists, destination sym broken, succeed (unlink destination)" {
    source_file="$(mktemp)"
    rm "/tmp/test_symlink"
    ln -s "/tmp/broken_source" "/tmp/test_symlink"
    run _symlink "$source_file" "/tmp/test_symlink"
    assert_success
}
#
@test "destination sym exists, source exists, no write perm to destination, succeed (run as sudo)" {
    source_file="$(mktemp)"
    dest_directory="$(mktemp -d)"
    chmod 555 "$dest_directory" # read and execute permissions only
    source_name="$(basename "$source_file")"
    run _symlink "$source_file" "$dest_directory/$source_name"
    assert_success
}




