using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[RequireComponent(typeof(PostProcessVolume))]
public class SoundPostProcessingManager : MonoBehaviour
{
	public float		audioAmplitude { get; set; }

	PostProcessVolume	volume;

	Bloom				bloom;
	LensDistortion		lensDistortion;

	void Start ()
	{
		volume = GetComponent< PostProcessVolume >();
		volume.sharedProfile.TryGetSettings< Bloom >(out bloom);
		volume.sharedProfile.TryGetSettings< LensDistortion >(out lensDistortion);
	}
	
	void Update ()
	{
		if (lensDistortion != null)
		{
			lensDistortion.intensity.value = audioAmplitude * 80;
		}

		Debug.Log("audioAmplitude: " + audioAmplitude);
	}
}
