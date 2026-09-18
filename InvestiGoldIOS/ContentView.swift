import SwiftUI
import UIKit

struct ContentView: View {
    @State private var showDetails = false
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            // 1. BRANDING SECTION
            VStack(alignment: .leading, spacing: 6) {
                
                // Your SVG Logo + Text
                HStack(spacing: 16) {
                    Image("Logo") // Replace with your actual asset name
                        .resizable()                // Allows resizing
                        .scaledToFit()              // Maintains aspect ratio
                        .frame(width: 50, height: 50)
                    
                    Text("InvestiGold")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                }
                
                Text("Risk Free. Invest Easy.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.leading, 4) // Slight nudge for optical alignment
            }
            
            // 2. ACTION BUTTON
            Button(action: {
                // 2. Trigger the sheet
                showDetails.toggle()
            }) {
                Text("Get Started")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(Color.black)
                    .cornerRadius(5)
            }
            
            Spacer()
        }
        .padding(.top, 180)
        .padding(.leading, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
        
        // 3. The Bottom Sheet Modifier
        .sheet(isPresented: $showDetails) {
            OnboardingSheetView()
                // Sets the height of the slider (Medium = half screen, Large = full)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible) // The little "grabber" bar at the top
        }
    }
}

struct OnboardingSheetView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        // 1. ADD THE NAVIGATION STACK HERE
        NavigationStack {
            VStack(spacing: 25) {
                
                VStack(spacing: 8) {
                    Text("Welcome Back")
                        .font(.title2)
                        .bold()
                    Text("Please enter your details to continue.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                VStack(spacing: 15) {
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(12)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                
                VStack(spacing: 16) {
                    Button(action: {
                        print("Logging in with: \(email)")
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                    
                    // 2. SWAP THE BUTTON FOR A NAVIGATION LINK
                    NavigationLink(destination: RegisterView()) {
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.secondary)
                            Text("Register")
                                .bold()
                                .foregroundColor(.black)
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        } // End of NavigationStack
    }
}
#Preview {
    ContentView()
}
