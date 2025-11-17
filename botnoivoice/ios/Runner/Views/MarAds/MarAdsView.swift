import SwiftUI

struct MarAdsView: View {
    @State private var productToSell = ""
    @State private var brandName = ""
    @State private var price = ""
    @State private var selectedContentStyle = "จูงใจให้ใช้"
    @State private var selectedContentLength = "~15 วิ"
    @State private var showModeDropdown = false
    @State private var showStyleDropdown = false
    @State private var showLengthDropdown = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    topBar
                    
                    modeSelector
                    
                    formFields
                    
                    Spacer()
                }
                .background(Color(hex: "#F7F8FA"))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(systemName: "mic.fill")
                        .resizable()
                        .frame(width: 30, height: 34)
                        .foregroundColor(Color(hex: "#262626"))
                }
            }
        }
    }
    
    private var topBar: some View {
        HStack(spacing: 10) {
            Button(action: {}) {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(hex: "#3D3D3D"))
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                HStack(spacing: 10) {
                    Text("ฟรี")
                        .font(.custom("Prompt", size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#01BFFB"), Color(hex: "#EB85FC")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(100)
                }
                
                Text("10/10")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#262626"))
                    .padding(.horizontal, 4)
            }
            .padding(4)
            .background(Color.white)
            .cornerRadius(100)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    private var modeSelector: some View {
        HStack {
            Spacer()
            
            Button(action: {
                showModeDropdown.toggle()
            }) {
                HStack(spacing: 5) {
                    Text("Basic mode")
                        .font(.system(size: 12))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#01BFFB"), Color(hex: "#EB85FC")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 8, height: 5)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#01BFFB"), Color(hex: "#EB85FC")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(Color(hex: "#F7F8FA"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "#01BFFB"), Color(hex: "#EB85FC")],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
    
    private var formFields: some View {
        VStack(alignment: .leading, spacing: 0) {
            StyledTextField(
                label: "สินค้าที่ต้องการขาย*",
                placeholder: "คอร์สสอนภาษา, โทรศัพท์มือถือ, ...",
                text: $productToSell
            )
            
            StyledTextField(
                label: "ชื่อแบรนด์/ชื่อยี่ห้อ",
                placeholder: "บอทน้อย",
                text: $brandName
            )
            
            StyledTextField(
                label: "ราคา",
                placeholder: "129 บาท, 99 บาท จาก 129 บาท",
                text: $price
            )
            
            StyledDropdown(
                label: "สไตล์เนื้อหา",
                selectedValue: $selectedContentStyle,
                isExpanded: $showStyleDropdown
            )
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 4) {
                    Text("ความยาวของเนื้อหา* (มีผลต่อพอยท์ที่ใช้)")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#262626"))
                    
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color(hex: "#262626"))
                }
                
                StyledDropdown(
                    label: nil,
                    selectedValue: $selectedContentLength,
                    isExpanded: $showLengthDropdown
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .frame(height: 89)
            
            Text("ข้อมูลเสริมอื่นๆ (ไม่จำเป็นต้องกรอก)")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#262626"))
                .padding(.horizontal, 16)
                .padding(.vertical, 5)
                .frame(height: 30)
            
            bottomButton
        }
    }
    
    private var bottomButton: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color(hex: "#262626"))
                
                Text("สร้างได้ 10 ครั้ง")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#262626"))
                
                Spacer()
            }
            .padding(.bottom, 16)
            
            Button(action: {}) {
                Text("สร้างข้อความ")
                    .font(.custom("Lexend", size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#262626"))
                    .cornerRadius(20)
            }
            .disabled(true)
            .opacity(0.25)
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.white),
            alignment: .top
        )
    }
}

struct StyledTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#262626"))
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Color(hex: "#888888")))
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#262626"))
                .padding(20)
                .frame(height: 49)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isFocused ? Color(hex: "#888888") : Color.white, lineWidth: 1)
                )
                .focused($isFocused)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
        .frame(height: 89)
    }
}

struct StyledDropdown: View {
    let label: String?
    @Binding var selectedValue: String
    @Binding var isExpanded: Bool
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let label = label {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#262626"))
            }
            
            Button(action: {
                isExpanded.toggle()
            }) {
                HStack {
                    Text(selectedValue)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#262626"))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 8, height: 5)
                        .foregroundColor(Color(hex: "#262626"))
                }
                .padding(20)
                .frame(height: 46)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isPressed ? Color(hex: "#888888") : Color.white, lineWidth: 1)
                )
            }
            .buttonStyle(DropdownButtonStyle(isPressed: $isPressed))
        }
        .padding(.horizontal, label != nil ? 16 : 0)
        .padding(.vertical, label != nil ? 5 : 0)
        .frame(height: label != nil ? 89 : nil)
    }
}

struct DropdownButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    MarAdsView()
}
