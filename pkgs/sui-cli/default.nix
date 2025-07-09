{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, zlib
, libgcc
}:

let
  version = "1.51.4";
  
  # Platform-specific configuration
  platformConfig = {
    x86_64-linux = {
      url = "https://github.com/MystenLabs/sui/releases/download/testnet-v${version}/sui-testnet-v${version}-ubuntu-x86_64.tgz";
      hash = "sha256-qc8ZaooiR8Bf6hTz3iK/aoBkQnisupOBpllWMH0h4/M=";
    };
    aarch64-linux = {
      url = "https://github.com/MystenLabs/sui/releases/download/testnet-v${version}/sui-testnet-v${version}-ubuntu-aarch64.tgz";
      hash = "sha256-0Vmibtu2yTOjDabd3PG1GeXfstPZo6zPib/4Q23SXe8=";
    };
    x86_64-darwin = {
      # Note: Using Linux binary for macOS as there's no native macOS binary
      # This may require additional compatibility layers
      url = "https://github.com/MystenLabs/sui/releases/download/testnet-v${version}/sui-testnet-v${version}-ubuntu-x86_64.tgz";
      hash = "sha256-qc8ZaooiR8Bf6hTz3iK/aoBkQnisupOBpllWMH0h4/M=";
    };
    aarch64-darwin = {
      # Note: Using Linux binary for macOS as there's no native macOS binary
      # This may require additional compatibility layers
      url = "https://github.com/MystenLabs/sui/releases/download/testnet-v${version}/sui-testnet-v${version}-ubuntu-aarch64.tgz";
      hash = "sha256-0Vmibtu2yTOjDabd3PG1GeXfstPZo6zPib/4Q23SXe8=";
    };
  };
  
  # Get platform configuration for current system
  platform = platformConfig.${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
  
in stdenv.mkDerivation {
  pname = "sui-cli";
  inherit version;
  
  src = fetchurl {
    inherit (platform) url hash;
  };
  
  # Dependencies for Linux systems
  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];
  
  buildInputs = lib.optionals stdenv.isLinux [
    zlib
    libgcc.lib
  ];
  
  # Don't strip debug symbols as they might be needed for the binary
  dontStrip = true;
  
  # Extract and install
  installPhase = ''
    runHook preInstall
    
    # Create bin directory
    mkdir -p $out/bin
    
    # Copy the sui binary
    cp sui $out/bin/sui
    
    # Make it executable
    chmod +x $out/bin/sui
    
    # Copy other related binaries if they exist
    for bin in sui-tool sui-debug sui-test-validator move-analyzer sui-graphql-rpc sui-bridge-cli sui-data-ingestion sui-bridge; do
      if [ -f "$bin" ]; then
        cp "$bin" $out/bin/
        chmod +x $out/bin/"$bin"
      fi
    done
    
    runHook postInstall
  '';
  
  # Platform-specific post-installation fixes
  postInstall = lib.optionalString stdenv.isDarwin ''
    # For macOS, we might need to handle signing or other platform-specific requirements
    # This is a placeholder for future macOS-specific handling
  '' + lib.optionalString stdenv.isLinux ''
    # For Linux, autoPatchelfHook should handle most dependencies
    # Additional Linux-specific handling can be added here
  '';
  
  meta = with lib; {
    description = "Sui CLI - Command line interface for the Sui blockchain";
    homepage = "https://github.com/MystenLabs/sui";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = [ ];
    mainProgram = "sui";
  };
}
