using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[RequireComponent(typeof(PostProcessVolume))]
public class SoundPostProcessingManager : MonoBehaviour
{
	public float		audioAmplitude { get; set; }

	[Space, Header("SmoothTimes")]
	public float		amplitudeSmoothTime = .08f;
	public float		audioTimeSmoothTime = .1f;

	[Space]
	public float		audioTimeAmplitude = 8;

	[Space]
	public MeshRenderer	fractalRenderer;

	PostProcessVolume	volume;

	Bloom				bloom;
	LensDistortion		lensDistortion;
	ChromaticAberration	chromaticAberration;

	float				defaultBloomValue;

	float				smoothedAmplitude;
	float				amplitudeVelocity;

	float				audioTime = 0;
	float				audioTimeVelocity;

	void Start ()
	{
		volume = GetComponent< PostProcessVolume >();
		volume.sharedProfile.TryGetSettings< Bloom >(out bloom);
		volume.sharedProfile.TryGetSettings< LensDistortion >(out lensDistortion);
		volume.sharedProfile.TryGetSettings< ChromaticAberration >(out chromaticAberration);

		defaultBloomValue = bloom.intensity.value;
	}
	
	void Update ()
	{
		UpdateSmooth();

		UpdatePostProcessing();
	}

	void UpdateSmooth()
	{
		smoothedAmplitude = Mathf.SmoothDamp(smoothedAmplitude, audioAmplitude, ref amplitudeVelocity, amplitudeSmoothTime);

		float s = audioTime + Time.deltaTime * Mathf.Max(.5f, audioAmplitude * 8);
		audioTime = Mathf.SmoothDamp(audioTime, s, ref audioTimeVelocity, audioTimeSmoothTime);
	}

	void UpdatePostProcessing()
	{
		float amp = smoothedAmplitude;

		lensDistortion.intensity.value = -amp * 80;
		chromaticAberration.intensity.value = amp;
		bloom.intensity.value = defaultBloomValue + amp * 2;

		fractalRenderer.material.SetFloat("_AudioTime", audioTime);
	}
}
