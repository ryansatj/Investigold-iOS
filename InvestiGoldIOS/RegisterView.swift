import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Networking States
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showSuccessMessage = false
    
    var body: some View {
        VStack(spacing: 25) {
            // Header
            VStack(spacing: 8) {
                Text("Create Account")
                    .font(.title2)
                    .bold()
                Text("Join InvestiGold today.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            
            // Inputs
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
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            
            // Action Button
            Button(action: {
                // 1. Basic UI Validation
                errorMessage = ""
                guard !email.isEmpty, !password.isEmpty else {
                    errorMessage = "Please fill in all fields."
                    return
                }
                guard password == confirmPassword else {
                    errorMessage = "Passwords do not match."
                    return
                }
                
                // 2. Trigger the network call
                Task {
                    await registerUserToNeon()
                }
            }) {
                // Show a spinner if loading, otherwise show text
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(12)
                } else {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
            .disabled(isLoading) // Prevent double-clicks
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            // Feedback Text
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            if showSuccessMessage {
                Text("Registration Successful! You can now log in.")
                    .foregroundColor(.green)
                    .font(.footnote)
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Networking Function
    func registerUserToNeon() async {
        isLoading = true
        showSuccessMessage = false
        
        // 1. The URL (localhost works because the Simulator runs on your Mac)
        guard let url = URL(string: "http://localhost:3000/register") else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        // 2. Set up the POST request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3. Attach the email and password as JSON
        let bodyPayload = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyPayload)
        
        do {
            // 4. Send it!
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 5. Check the result
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    // It worked!
                    showSuccessMessage = true
                    email = ""
                    password = ""
                    confirmPassword = ""
                } else {
                    // Server sent back an error (e.g., email already exists)
                    errorMessage = "Failed to register. Try a different email."
                    print("Server Error Data: \(String(data: data, encoding: .utf8) ?? "")")
                }
            }
        } catch {
            errorMessage = "Could not connect to the server."
            print("Network Error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
