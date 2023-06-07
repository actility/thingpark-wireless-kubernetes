# Azure profiles
flavors=(azure amazon alicloud)
segment=(l)
unsupported=()

for f in "${flavors[@]}"
do
    echo "Generate $f configs"
    rm -vr ${f}
    mkdir -vp ${f}
    for s in "${segment[@]}"
    do
        if [ -f  reference/${f}/values-${s}-segment.yaml ]; then
        cloud_values="reference/${f}/values-${s}-segment.yaml"
        else 
        cloud_values="reference/${f}/values.yaml"
        fi
        echo "Generate $s configs for $f"
            yq eval-all '. as $item ireduce ({}; . * $item)' reference/values-selectors.yaml \
                reference/compute/values-${s}-segment.yaml \
                reference/storage/values-${s}-segment.yaml \
                ${cloud_values} | tee ${f}/values-${s}-segment.yaml
    done
done
 
for item in "${unsupported[@]}"
do
    if [ -f ${item} ]; then
        rm -v ${item}
    fi
done