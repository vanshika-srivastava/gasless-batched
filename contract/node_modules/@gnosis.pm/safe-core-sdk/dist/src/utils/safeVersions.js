"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.hasFeature = exports.enabledFeatures = exports.FEATURES = void 0;
const satisfies_1 = __importDefault(require("semver/functions/satisfies"));
var FEATURES;
(function (FEATURES) {
    FEATURES[FEATURES["SAFE_TX_GAS_OPTIONAL"] = 0] = "SAFE_TX_GAS_OPTIONAL";
})(FEATURES = exports.FEATURES || (exports.FEATURES = {}));
const FEATURES_BY_VERSION = {
    [FEATURES.SAFE_TX_GAS_OPTIONAL]: '>=1.3.0'
};
const isEnabledByVersion = (feature, version) => {
    if (!(feature in FEATURES_BY_VERSION)) {
        return true;
    }
    return (0, satisfies_1.default)(version, FEATURES_BY_VERSION[feature]);
};
const enabledFeatures = (version) => {
    const features = Object.values(FEATURES);
    return features.filter((feature) => isEnabledByVersion(feature, version));
};
exports.enabledFeatures = enabledFeatures;
const hasFeature = (name, version) => {
    return (0, exports.enabledFeatures)(version).includes(name);
};
exports.hasFeature = hasFeature;
//# sourceMappingURL=safeVersions.js.map