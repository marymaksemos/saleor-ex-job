import NextImage from "next/image";
import { LinkWithChannel } from "../atoms/LinkWithChannel";
import { ProductQuickView } from "./ProductQuickView";
import { ProductQuickAdd } from "./ProductQuickAdd";
import { formatMoneyRange } from "@/lib/utils";
import { type ProductListItemFragment } from "@/gql/graphql";

interface ProductElementProps {
	product: ProductListItemFragment;
	loading: "eager" | "lazy";
	priority?: boolean;
}

export function ProductElement({ product, loading, priority }: ProductElementProps) {
	return (
		<div className="rounded-lg border bg-white p-4 shadow-lg">
			<div className="relative space-y-4 ">
				<div className="group relative aspect-square overflow-hidden">
					{product?.thumbnail?.url && (
						<NextImage
							className="h-full w-full object-contain object-center"
							loading={loading}
							src={product.thumbnail.url}
							alt={product.thumbnail.alt ?? ""}
							width={512}
							height={512}
							sizes={"640px"}
							priority={priority}
						/>
					)}
					<div className="absolute inset-0 hidden items-center justify-center backdrop-blur-sm group-hover:flex">
						<ProductQuickView product={product} />
					</div>
				</div>
				<div>
					<LinkWithChannel href={`/products/${product.slug}`}>
						<h3 className="line-clamp-2 max-h-10 min-h-10 hyphens-auto text-sm text-gray-600 hover:underline">
							{product.name}
						</h3>
					</LinkWithChannel>
					<p className="text-md text-orange-600" data-testid="ProductElement_PriceRange">
						{formatMoneyRange({
							start: product?.pricing?.priceRange?.start?.gross,
							stop: product?.pricing?.priceRange?.stop?.gross,
						})}
					</p>
					<ProductQuickAdd
						product={product}
						hasQuickAdd={!!product.variants?.length && product.variants.length > 1}
					/>
				</div>
			</div>
		</div>
	);
}
