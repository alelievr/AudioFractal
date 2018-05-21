using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FullScreenQuad : MonoBehaviour
{

	void Start ()
	{
		float quadHeight = Camera.main.orthographicSize * 2.0f;
		float quadWidth = quadHeight * Screen.width / Screen.height;
		transform.localScale = new Vector3(quadWidth, quadHeight, 1);
	}
	
	void Update () {
		
	}
}
