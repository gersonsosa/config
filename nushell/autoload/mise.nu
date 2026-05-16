alias mx = mise exec 
alias mr = mise run 
let vendor_dir = $nu.vendor-autoload-dirs | last
let mise_path = $vendor_dir | path join mise.nu

mkdir $vendor_dir
^mise activate nu | save $mise_path --force
