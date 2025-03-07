import Vapor

/**
 * Configure routes for the TwapsServer
 *
 * This function sets up the routes for the TwapsServer, including:
 * - A root route that returns a simple message
 * - A route for retrieving Twaps by URL
 * - A route for pushing Twaps to the server
 *
 * - Parameter app: The Vapor application to configure
 */
func routes(_ app: Application) throws {
    // Root route - returns a simple message to confirm the server is running
    app.get { req async in
        "It works!"
    }
    
    /**
     * GET /twap
     *
     * Retrieves a Twap by URL.
     * The client sends the Twap URL in the request body, and the server returns the Twap source code.
     * This route is used by the TwapsClient to load Twaps.
     */
    app.post("twap") { req -> String in
        // Attempt to extract the raw string from the request body.
        // This should be the URL of the Twap to retrieve.
        guard let bodyString = req.body.string else {
            throw Abort(.badRequest, reason: "No body string provided")
        }
        
        // Path to the twaps.json file in the user's home directory
        // This file contains all the Twaps that have been pushed to the server
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        let fileURL = homeDirectory.appendingPathComponent(".twaps").appendingPathComponent("twaps.json")
        
        // Check if the file exists
        // If not, return an error message
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw Abort(.notFound, reason: "Twaps file not found. Please push a Twap first.")
        }
        
        // Read the twaps.json file and decode it into an array of Twaps
        let data = try Data(contentsOf: fileURL)
        let twaps = try JSONDecoder().decode([Twap].self, from: data)
        
        // Find the Twap with the requested URL
        for twap in twaps {
            if twap.url == bodyString {
                // Replace escaped newlines with actual newlines
                // This is necessary because the source code is stored with escaped newlines
                let formattedString = twap.source.replacingOccurrences(of: "\\n", with: "\n")
                return formattedString
            }
        }
        
        // If no Twap with the requested URL is found, return an error message
        return "Twap not found with URL: \(bodyString)"
    }
    
    /**
     * POST /api/twaps
     *
     * Pushes a Twap to the server.
     * The client sends the Twap as JSON in the request body, and the server saves it to the twaps.json file.
     * This route is used by the TwapsCLI to push Twaps to the server.
     */
    app.post("api", "twaps") { req -> Response in
        // Decode the Twap from the request body
        let twap = try req.content.decode(Twap.self)
        
        // Path to the twaps.json file in the user's home directory
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        let fileURL = homeDirectory.appendingPathComponent(".twaps").appendingPathComponent("twaps.json")
        
        // Create the directory if it doesn't exist
        let directoryURL = fileURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        
        // Read existing twaps or create a new array
        var twaps: [Twap] = []
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                twaps = try JSONDecoder().decode([Twap].self, from: data)
            } catch {
                // If there's an error reading the file, we'll just start with an empty array
                req.logger.warning("Could not read existing twaps.json file: \(error.localizedDescription)")
            }
        }
        
        // Remove any existing Twap with the same URL
        // This ensures that pushing a Twap with the same URL will replace the old one
        twaps.removeAll { $0.url == twap.url }
        
        // Add the new Twap to the array
        twaps.append(twap)
        
        // Write the updated array back to the file
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        let data = try encoder.encode(twaps)
        try data.write(to: fileURL)
        
        // Return a success response with the Twap URL
        let response = Response(status: .created)
        try response.content.encode(["message": "Twap successfully pushed", "url": twap.url])
        return response
    }
}
