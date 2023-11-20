import numpy as np
import matplotlib.pyplot as plt


def function(x):
    return 10 * np.sin(x) ** 2


values = np.arange(0, 10, 0.1)
y_values = function(values)
plt.plot(values, y_values, label='f(x) = 10 * (sin(x))^2')
plt.title('Graph of the function f(x): G_f')
plt.xlabel('x')
plt.ylabel('f(x)')
plt.legend()
plt.grid(True)
plt.savefig('python_output.png')
