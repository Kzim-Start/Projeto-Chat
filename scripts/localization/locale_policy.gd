class_name LocalePolicy
extends RefCounted

const SUPPORTED := ["pt_BR", "en"]
const FALLBACK := "en"


static func from_device_locale(device_locale: String) -> String:
	var language := device_locale.replace("-", "_").get_slice("_", 0).to_lower()
	return "pt_BR" if language == "pt" else FALLBACK


static func is_supported(locale: String) -> bool:
	return locale in SUPPORTED
