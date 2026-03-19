# TR: KUBBE V4 Font Download Script - OFFLINE DESTEK
# EN: KUBBE V4 Font Download Script - OFFLINE SUPPORT
# TR: Bu script Google Fonts'tan font dosyalarını indirir
# EN: This script downloads font files from Google Fonts
# TR: İnternet bağlantısı olmadan font kullanımını sağlar
# EN: Enables font usage without internet connection

# TR: Gereksinimler: curl veya wget
# EN: Requirements: curl or wget

# TR: Font bilgileri
# EN: Font information
declare -A fonts=(
    ["Outfit-Regular"]="https://fonts.gstatic.com/s/outfit/v11/QGYvz_MVcBeFP4xwcxw.woff2"
    ["Outfit-Medium"]="https://fonts.gstatic.com/s/outfit/v11/QGYyz_MVcBeFP4xwcxw.woff2"
    ["Outfit-Bold"]="https://fonts.gstatic.com/s/outfit/v11/QGYsz_MVcBeFP4xwcxw.woff2"
    ["Outfit-Black"]="https://fonts.gstatic.com/s/outfit/v11/QGY2z_MVcBeFP4xwcxw.woff2"
    ["Poppins-Regular"]="https://fonts.gstatic.com/s/poppins/v20/pxiEyp8kv8JHgFVrJJfecg.woff2"
    ["Poppins-Medium"]="https://fonts.gstatic.com/s/poppins/v20/pxiByp8kv8JHgFVrLz9Z1JlFc-K.woff2"
    ["Poppins-Bold"]="https://fonts.gstatic.com/s/poppins/v20/pxiByp8kv8JHgFVrLz9Z1JlFc-K.woff2"
    ["Poppins-Black"]="https://fonts.gstatic.com/s/poppins/v20/pxiByp8kv8JHgFVrLz9Z1JlFc-K.woff2"
    ["Inter-Regular"]="https://fonts.gstatic.com/s/inter/v13/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuLyfAZ9hiA.woff2"
    ["Inter-Medium"]="https://fonts.gstatic.com/s/inter/v13/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuGKYAZ9hiA.woff2"
    ["Inter-SemiBold"]="https://fonts.gstatic.com/s/inter/v13/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuGKYAZ9hiA.woff2"
    ["Inter-Bold"]="https://fonts.gstatic.com/s/inter/v13/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuGKYAZ9hiA.woff2"
)

# TR: Ana fonksiyon
# EN: Main function
main() {
    echo "TR: KUBBE V4 Font İndirme Başlatıldı"
    echo "EN: KUBBE V4 Font Download Started"
    
    # TR: assets/fonts klasörünü oluştur
    # EN: Create assets/fonts folder
    mkdir -p assets/fonts
    echo "TR: assets/fonts klasörü oluşturuldu"
    echo "EN: assets/fonts folder created"
    
    # TR: Font dosyalarını indir
    # EN: Download font files
    local success=true
    for font_name in "${!fonts[@]}"; do
        url="${fonts[$font_name]}"
        filename="${font_name}.woff2"
        filepath="assets/fonts/$filename"
        
        echo "TR: $filename indiriliyor..."
        echo "EN: Downloading $filename..."
        
        # TR: curl ile indir
        # EN: Download with curl
        if command -v curl &> /dev/null; then
            if curl -s -o "$filepath" "$url"; then
                echo "TR: $filename indirildi"
                echo "EN: $filename downloaded"
            else
                echo "TR: $filename indirilemedi"
                echo "EN: $filename download failed"
                success=false
            fi
        # TR: wget ile indir
        # EN: Download with wget
        elif command -v wget &> /dev/null; then
            if wget -q -O "$filepath" "$url"; then
                echo "TR: $filename indirildi"
                echo "EN: $filename downloaded"
            else
                echo "TR: $filename indirilemedi"
                echo "EN: $filename download failed"
                success=false
            fi
        else
            echo "TR: curl veya wget bulunamadı"
            echo "EN: curl or wget not found"
            success=false
            break
        fi
    done
    
    if [ "$success" = true ]; then
        echo "TR: Font indirme tamamlandı!"
        echo "EN: Font download completed!"
        echo "TR: Lütfen pubspec.yaml dosyasını kontrol edin"
        echo "EN: Please check pubspec.yaml file"
        echo "TR: ve \"flutter pub get\" komutunu çalıştırın"
        echo "EN: and run \"flutter pub get\" command"
    else
        echo "TR: Bazı font dosyaları indirilemedi"
        echo "EN: Some font files could not be downloaded"
        exit 1
    fi
}

# TR: Script'i çalıştır
# EN: Run script
main
