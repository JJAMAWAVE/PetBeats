from twelvelabs import TwelveLabs
import inspect

API_KEY = "tlk_1MYJ9F31G1EGRW25EG8SA0KT3742"
client = TwelveLabs(api_key=API_KEY)

print("--- Docstring of client.search.query ---")
print(client.search.query.__doc__)

print("\n--- Signature of client.search.query ---")
try:
    sig = inspect.signature(client.search.query)
    print(sig)
    for name, param in sig.parameters.items():
        print(f"Param: {name}, Kind: {param.kind}")
except Exception as e:
    print(f"Signature error: {e}")
