Shader "Custom/alphaBlend"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // Tags 설정을 Transparent 로 바꿈으로써, 현재 쉐이더를 '알파 블렌드 쉐이더(반투명 쉐이더)'로 변환함.
        // 이게 무슨 의미냐면, 이제 이 쉐이더가 적용된 오브젝트(메쉬)는 불투명 오브젝트가 다 그려질 때까지 기다린다는 의미임.
        // 정확히 말하면, "Queue"="Transparent" 로 설정하면, 불투명 오브젝트 다음에 그리라는 명령으로 보면 됨.
        // 왜 반투명 쉐이더로 바꿨을까? 지금 Quad 메쉬에 적용하는 텍스쳐가 반투명 처리가 되어야 하는 풀 텍스쳐라서!
        // 반투명 오브젝트 렌더링 처리 관련 내용은 p.454 ~ 456 참고
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        cull off // 면 추려내기를 비활성화해서 풀 텍스쳐를 입힌 Quad 의 양면이 모두 렌더링될 수 있도록 함.

        CGPROGRAM

        // Lambert 라이트 기본형으로 시작
        #pragma surface surf Lambert alpha:fade // alpha:fade 까지 추가해줘야 알파 블렌딩 쉐이더로 변경됨.

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }

    // FallBack "Diffuse"
    FallBack "Legacy Shaders/Tranparent/VertexLit" // Plane(바닥판)을 추가할 시 드리우는 Quad 의 그림자를 제거하기 위해 FallBack 셰이더를 변경함.
}

/*
    FallBack 쉐이더

    원래 FallBack 에 지정하는 쉐이더는
    현재 쉐이더를 표현하는 것에 실패할 경우,
    대체해서 사용할 '예비용 쉐이더'를 지정하는 키워드이지만,

    위에서 처럼
    '그림자'에 관련한 쉐이더를 지정할 때에도
    FallBack 에 지정된 예비용 쉐이더가 적용되는 것을
    확인할 수 있음.

    그래서 위에서 처럼 유니티 내장 쉐이더 중에서
    Legacy Shaders/Transparent/... 디렉토리에 저장된 쉐이더를
    아무거나 가져와서 그림자에 적용하면
    그림자가 사라지게 할 수 있음.
*/