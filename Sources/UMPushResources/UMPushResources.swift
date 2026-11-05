// This target exists solely to ship `UMPushResource.bundle` into the app
// bundle and to declare UMPush's SwiftPM-level dependency on UMCommon
// (binary targets cannot declare dependencies directly).
// No public API is exposed to consumers.
import Foundation
