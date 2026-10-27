# CarharttWIP SwiftUI Demo

A clothing discovery demo: react to up to ten products by swiping left (dislike), right (like) or up (superlike), then review and edit your selection. Accessible buttons offer the same actions. The catalog is bundled JSON; product images load from their original remote URLs.

![Screen recording of the original demo](https://github.com/user-attachments/assets/7646813f-a73a-445f-a54e-fb9e4c3203da)

The recording shows the original UI. The refactor adds reaction buttons and explicit loading, empty and error states.

## Run

- Xcode 16 or newer, with Swift 6 language support.
- iOS 17.2 or newer.
- No third-party dependencies or API credentials.

Open `CarharttWIP.xcodeproj`, select the shared `CarharttWIP` scheme and run on an iOS simulator. Device installation requires your own signing configuration.

## Architecture

The presentation pattern is adapted from Mestria: **View → ViewModel → Interactor → UseCase → Repository → DataSource**. A ViewModel presents read-only state and handles typed actions; a feature Router names destinations; a ViewBuilder wires each scene. `AppDependencies` constructs the concrete dependency graph and `AppRouter` owns navigation.

| Area | Responsibility |
| --- | --- |
| `Presentation` | SwiftUI rendering, MainActor state, actions, gesture interpretation and navigation. |
| `Domain` | Entities, repository contracts, round invariants and recommendation rules. |
| `Data` | Bundled catalog access and DTO mapping. |
| `Managers` | Actor-isolated file reading and JSON decoding. |
| `Preview Content` | In-memory preview dependencies, excluded from Release behavior. |

`GameSession` limits a round to ten distinct products and accepts each current product once. An empty catalog stays on an empty state; a failed load exposes a retry. Results are presented only after a nonempty round finishes. Closing results starts a fresh round; closing the game returns home.

See the [architecture audit and decisions](docs/architecture-audit.md) for the original defects, tradeoffs, validation scope and suggested commit boundaries.

## Tests

```bash
Scripts/test-ios.sh

# Select a particular installed simulator and run only unit tests:
SIMULATOR_UDID=<device-uuid> Scripts/test-ios.sh -only-testing:CarharttWIPTests
```

The script selects an available iPhone simulator by default. It supports `DERIVED_DATA_PATH` and `RESULT_BUNDLE_PATH` overrides; results default to `.build/`.

- Swift Testing covers domain rules, real catalog decoding, presentation transitions, cancellation, retry and routing. It uses deterministic inputs and controlled continuations instead of timed waits.
- XCUITest covers a full round, demo cart feedback, replay, closing the game, an all-disliked round and directional swipes.
- [GitHub Actions](.github/workflows/ios.yml) runs the same suite with coverage, builds Release and uploads the test result bundle.

## Demo scope

This is an educational project with an in-memory selection. “Add to cart” displays explicitly labeled demo feedback; it does not create an order. The catalog does not rotate daily. Image availability depends on the source CDN. English is the only supplied UI language.

## Contributions

Open an issue to discuss a change, or submit a pull request with the behavior it improves and the checks used to verify it.

## Disclaimer

All images used in this demo app are the property of **Carhartt**. This project is intended solely for educational and demonstration purposes. The developer does not claim any ownership of these images. 

Carhartt retains all rights to the images, logos, and any other intellectual property associated with its brand. The developer is not responsible for any legal issues that may arise from the use of these materials.

If you are the rights holder and wish for these images to be removed, please contact us, and we will promptly take them down.

## License

This project is licensed under the [MIT License](LICENSE).
