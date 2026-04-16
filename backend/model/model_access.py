import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
from tensorflow.keras.preprocessing import image

# Load model
model = tf.keras.models.load_model(r"rice_disease_model.keras")

# Class names in the same order used during training
class_names = [
    "Bacterial Leaf Blight",
    "Brown Spot",
    "Healthy Rice Leaf",
    "Leaf Blast",
    "Leaf scald",
    "Sheath Blight"
]

# Fertilizer recommendation map
fertilizer_map = {
    "Bacterial Leaf Blight": "Use MOP, avoid excess Urea",
    "Brown Spot": "Use MOP, TSP",
    "Healthy Rice Leaf": "No need of fertilizer",
    "Leaf Blast": "Use MOP, avoid excess Urea",
    "Leaf scald": "Use MOP",
    "Sheath Blight": "Use MOP, avoid excess Urea"
}

# Image path
img_path = r"./Screenshot 2026-04-17 010138.png"   # change this to your image path

# Load and preprocess image
img = image.load_img(img_path, target_size=(128, 128))
img_array = image.img_to_array(img)
input_array = np.expand_dims(img_array, axis=0)

# Prediction
predictions = model.predict(input_array)
probabilities = tf.nn.softmax(predictions[0]).numpy()

predicted_index = np.argmax(probabilities)
predicted_class = class_names[predicted_index]
confidence = probabilities[predicted_index] * 100
fertilizer = fertilizer_map[predicted_class]

# Print result
print("Predicted disease:", predicted_class)
print(f"Confidence: {confidence:.2f}%")
print("Fertilizer recommendation:", fertilizer)

# Show image with result
plt.imshow(img_array.astype("uint8"))
plt.title(
    f"Disease: {predicted_class}\n"
    f"Confidence: {confidence:.2f}%\n"
    f"Fertilizer: {fertilizer}"
)
plt.axis("off")
plt.show()