
from julia import Main

Main.eval("""
import Pkg
Pkg.activate("Data")
using Data
""")

print("Done.")